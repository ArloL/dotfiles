#!/usr/bin/env bash
############################
# Generate the Automator Quick Actions listed in services.conf and install them
# into ~/Library/Services.
#
# Each service is only installed when its app is installed, and its Finder
# context menu icon is copied from that app bundle.
#
# Pass --prune to also remove managed services whose app has since been
# uninstalled.
############################

set -o errexit
set -o nounset

scriptPath=$( cd "$( dirname "$0" )" && pwd )

readonly servicesDir="${HOME}/Library/Services"
readonly templateDir="${scriptPath}/templates"
readonly configFile="${scriptPath}/services.conf"

prune=0
if [ "${#}" -gt "0" ] && [ "${1}" = "--prune" ]; then
    prune=1
fi

# Print the path of the app with the given bundle id, or nothing when the app
# is not installed. Launch Services also finds apps outside /Applications.
resolveApp() {
    local bundleId=${1}
    local appPath

    appPath=$(osascript -e "POSIX path of (path to application id \"${bundleId}\")" 2>/dev/null) || return 0

    # strip the trailing slash osascript adds
    echo "${appPath%/}"
}

# Print the path of an app's .icns file, or nothing when it has none.
resolveIcon() {
    local appPath=${1}
    local iconName

    iconName=$(defaults read "${appPath}/Contents/Info" CFBundleIconFile 2>/dev/null) || return 0

    # CFBundleIconFile may or may not carry the extension
    case "${iconName}" in
        *.icns) ;;
        *) iconName="${iconName}.icns" ;;
    esac

    local iconPath="${appPath}/Contents/Resources/${iconName}"
    if [ -f "${iconPath}" ]; then
        echo "${iconPath}"
    fi
}

installService() {
    local name=${1}
    local bundleId=${2}
    local fileTypes=${3}
    local shellCommand=${4}

    local target="${servicesDir}/${name}.workflow"

    local appPath
    appPath=$(resolveApp "${bundleId}")

    if [ -z "${appPath}" ]; then
        if [ -d "${target}" ] && [ "${prune}" -eq "1" ]; then
            echo "Removing ${name}, ${bundleId} is no longer installed"
            rm -rf "${target}"
        elif [ -d "${target}" ]; then
            echo "Skipping ${name}, ${bundleId} is not installed (run with --prune to remove it)"
        else
            echo "Skipping ${name}, ${bundleId} is not installed"
        fi
        return
    fi

    # folders only, or any file system object
    local inputType="com.apple.Automator.fileSystemObject"
    if [ "${fileTypes}" = "public.folder" ]; then
        inputType="com.apple.Automator.fileSystemObject.folder"
    fi

    rm -rf "${target}"
    mkdir -p "${target}/Contents/Resources"
    cp "${templateDir}/Info.plist" "${target}/Contents/Info.plist"
    cp "${templateDir}/document.wflow" "${target}/Contents/document.wflow"

    # plutil takes care of escaping the values for us
    plutil -replace NSServices.0.NSMenuItem.default -string "${name}" "${target}/Contents/Info.plist"
    plutil -replace NSServices.0.NSSendFileTypes -json "[\"${fileTypes}\"]" "${target}/Contents/Info.plist"

    plutil -replace actions.0.action.ActionParameters.COMMAND_STRING -string "${shellCommand}" "${target}/Contents/document.wflow"
    plutil -replace workflowMetaData.inputTypeIdentifier -string "${inputType}" "${target}/Contents/document.wflow"
    plutil -replace workflowMetaData.serviceInputTypeIdentifier -string "${inputType}" "${target}/Contents/document.wflow"

    local iconPath
    iconPath=$(resolveIcon "${appPath}")

    if [ -n "${iconPath}" ]; then
        cp "${iconPath}" "${target}/Contents/Resources/workflowCustomImage.icns"
    else
        echo "No icon found in ${appPath}, falling back to the default icon"
        plutil -remove NSServices.0.NSIconName "${target}/Contents/Info.plist"
    fi

    echo "Installed ${name}"
}

installGeneratedServices() {
    while IFS='|' read -r name bundleId fileTypes shellCommand; do

        # skip blank lines and comments
        case "${name}" in
            ''|'#'*) continue ;;
        esac

        installService "${name}" "${bundleId}" "${fileTypes}" "${shellCommand}"

    done < "${configFile}"
}

mkdir -p "${servicesDir}"

installGeneratedServices

# let the Services menu pick up the changes
/System/Library/CoreServices/pbs -flush
/System/Library/CoreServices/pbs -update

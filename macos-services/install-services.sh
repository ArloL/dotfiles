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

# the menus each service should be in, written once Automator has settled
restoreEntries=()
restoreModes=()

# every menu, matching the presentationMode of 15 in the template. A service the
# user has never seen gets this, one that is already known keeps what it has.
readonly allPresentationModes='<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0"><dict><key>presentation_modes</key><dict>
<key>ContextMenu</key><true/><key>FinderPreview</key><true/>
<key>ServicesMenu</key><true/><key>TouchBar</key><true/>
</dict></dict></plist>'

# Print the path of the app with the given bundle id, or nothing when the app is
# not installed. Spotlight also finds apps outside /Applications, and unlike
# asking Launch Services through osascript it does not launch the app it finds.
resolveApp() {
    local bundleId=${1}
    local matches

    matches=$(mdfind "kMDItemCFBundleIdentifier == '${bundleId}'" 2>/dev/null)

    # keep the first match, an app can be installed more than once
    echo "${matches%%$'\n'*}"
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

# pbs records which menus a service appears in, and keys it by
# "<bundle id> - <menu name> - <message>". An Automator workflow bundle carries
# no bundle id, hence the literal (null).
serviceEntry() {
    echo "(null) - ${1} - runWorkflowAsService"
}

# Print the menus a service currently appears in, or nothing when pbs has never
# recorded any.
readPresentationModes() {
    local entry=${1}

    # plutil fails when pbs has no record of the service, which is not an error
    defaults export pbs - \
        | plutil -extract "NSServicesStatus.${entry}" xml1 -o - - 2>/dev/null \
        || true
}

# Put a service back in the menus it was in before it was reinstalled. Saving a
# freshly generated bundle makes Automator record every menu, which would undo
# switching a service off by hand.
restorePresentationModes() {
    local entry=${1}
    local modes=${2}

    # the key keeps its quotes so defaults reads it as a string rather than
    # parsing (null) as an array
    defaults write pbs NSServicesStatus -dict-add "\"${entry}\"" "${modes}"
}

# Let Automator save the bundle once. Writing the files ourselves registers the
# service, it shows up enabled under Keyboard > Services, but the Finder leaves
# it out of the Quick Actions menu until Automator itself has saved it.
#
# This needs a session with a window server and, the first time, permission to
# control Automator.
resaveService() {
    local target=${1}

    osascript - "${target}" <<'APPLESCRIPT' > /dev/null
on run argv
    with timeout of 60 seconds
        tell application "Automator"
            set saved to open POSIX file (item 1 of argv)
            save saved
            close saved
        end tell
    end timeout
end run
APPLESCRIPT
}

# Report whether an installed service already matches the config, so that a run
# that changes nothing leaves it alone. Reinstalling costs an Automator save, and
# saving switches a service the user turned off back on.
serviceIsCurrent() {
    local target=${1}
    local fileTypes=${2}
    local inputType=${3}
    local shellCommand=${4}

    local infoPlist="${target}/Contents/Info.plist"
    local workflow="${target}/Contents/document.wflow"

    # Automator writes the thumbnail, so a bundle without one was generated but
    # never saved, and is still missing from the Quick Actions menu
    [ -f "${target}/Contents/QuickLook/Thumbnail.png" ] || return 1

    [ "$(plutil -extract NSServices.0.NSSendFileTypes.0 raw -o - "${infoPlist}" 2>/dev/null)" \
        = "${fileTypes}" ] || return 1
    [ "$(plutil -extract workflowMetaData.serviceInputTypeIdentifier raw -o - "${workflow}" 2>/dev/null)" \
        = "${inputType}" ] || return 1
    [ "$(plutil -extract actions.0.action.ActionParameters.COMMAND_STRING raw -o - "${workflow}" 2>/dev/null)" \
        = "${shellCommand}" ] || return 1
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

    if serviceIsCurrent "${target}" "${fileTypes}" "${inputType}" "${shellCommand}"; then
        echo "Keeping ${name}, already up to date"
        return
    fi

    local entry
    entry=$(serviceEntry "${name}")

    local previousModes
    previousModes=$(readPresentationModes "${entry}")

    rm -rf "${target}"
    mkdir -p "${target}/Contents"
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

    # Saving rebuilds Info.plist and Contents/Resources from the workflow, so the
    # icon has to go into the workflow rather than next to it. Automator writes
    # it back out as Contents/Resources/workflowCustomImage, without an
    # extension, and the Finder only identifies that file when it holds a png.
    if [ -n "${iconPath}" ]; then
        local pngPath="${TMPDIR:-/tmp}/install-services-icon.$$.png"

        sips --setProperty format png --out "${pngPath}" "${iconPath}" > /dev/null
        plutil -replace workflowMetaData.customImageFileData \
            -data "$(base64 --input "${pngPath}")" "${target}/Contents/document.wflow"
        rm -f "${pngPath}"
    else
        echo "No icon found in ${appPath}, falling back to the default icon"
    fi

    resaveService "${target}"

    # give the icon Automator just wrote back its extension
    local customImage="${target}/Contents/Resources/workflowCustomImage"
    if [ -f "${customImage}" ]; then
        mv "${customImage}" "${customImage}.png"
    fi

    # writing this here would not stick, see the loop at the end of the script
    if [ -z "${previousModes}" ]; then
        previousModes=${allPresentationModes}
    fi

    restoreEntries+=("${entry}")
    restoreModes+=("${previousModes}")

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

# Saving a workflow makes Automator record every menu for it, a second or two
# after the save returns, which would switch a service that was off back on.
# Wait for that to land before writing the menus each service belongs in.
if [ "${#restoreEntries[@]}" -gt "0" ]; then
    sleep 5

    for index in "${!restoreEntries[@]}"; do
        restorePresentationModes "${restoreEntries[${index}]}" "${restoreModes[${index}]}"
    done
fi

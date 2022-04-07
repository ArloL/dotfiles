# OS X Setup

* System Update
    * El Capitan: App Store...
    * Others: System Preferences -> Software Update
* Safari
    * Preferences
        * Search
            * Search engine: DuckDuckGo
* System Preferences
    * General
        * Appearance: Auto
        * Use dark menu bar and Dock: enabled
    * Dock
        * Automatically hide and show the Dock: enabled
        * Show recent applications in Dock: disabled
    * Mission Control
        * Hot Corners…
            * Top Left: Put Display To Sleep
            * Top Right: Mission Control
    * Language & Region
        * English as Primary
        * Region: Germany
    * El Capitan: Keyboard
        * Shortcuts
            * App Shortcuts
                * Terminal
                    * Show Previous Tab: Control+Shift+Tab
                    * Show Next Tab: Control+Tab
    * Keyboard
        * Modifier Keys…
            * Caps Lock Key: Escape
    * Trackpad
        * Point & Click
            * Tap to click: enabled
        * More Gestures
            * Swipe between full-screen apps: with four fingers
    * Sharing
        * Set Computer Name
        * edit local hostname
    * Displays
        * Night Shift
            * From 18:00 to 8:00
            * More Warm
    * Accessibility
        * Zoom
            * Enable Use scroll gesture with modifier keys to zoom
    * Time Machine
        * Options…
            * ~/.cache
            * ~/.docker
            * ~/.gluon/
            * ~/.local/share/containers/podman/machine
            * ~/.m2/repository
            * ~/.npm/_cacache
            * ~/.p2/pool
            * ~/.rbenv
            * ~/.sdkman
            * ~/.vagrant.d/boxes
            * ~/Developer
            * ~/Downloads
            * ~/Library/Caches <-- Excluded differently
            * ~/Library/Containers/com.docker.docker <-- Excluded differently
            * ~/Library/Containers/Docker <-- Excluded differently
            * ~/Library/Developer/CoreSimulator <-- Excluded differently
* Dock
    * add Applications List
    * add Import to iTunes
    * remove everything except Safari, Mail, iTunes, Calendar & Notes
* Finder
    * Preferences
        * General
            * New Finder windows show: ${HOME}
        * Sidebar
            * Disable: All My Files, iCloud Drive, AirDrop, Shared and Tags
            * Enable: ${HOME}
    * Change display to columns for all favorites
    * View
        * Show Status Bar
* https://github.com/tomislav/osx-terminal.app-colors-solarized/
* Terminal
    * Preferences
        * Profiles
            * Solarized Light as Default
* `sudo hostname -s ${name}`
* `git config --global credential.helper osxkeychain`
* `git clone https://github.com/ArloL/dotfiles.git ~/.dotfiles`
* `~/.dotfiles/install-osx.sh`
* `git push` to setup github credentials
* Mail
    * Preferences
        * iCloud
            * Mailbox Behaviours
                * Erase deleted messages: never
        * K5D
            * Mailbox Behaviours
                * Erase deleted messages: never
* El Capitan: Add "USERTrust RSA Certification Authority" root certificate
* MacPorts: https://www.macports.org/
    * `sudo port install nnn p7zip watch wget coreutils findutils mpstats`
* Homebrew: https://brew.sh/
    * El Capitan
        * `brew install git`
    * `brew install ssh-copy-id`
* No Night Shift?
    * `brew install homebrew/cask/flux`
    * Sunset: Tungsten
    * Bedtime: Candle
* Source Code Pro
    * `brew install homebrew/cask-fonts/font-source-code-pro`
    * Terminal
        * Preferences
            * Profiles
                * All
                    * Text: Source Code Pro 16pt
* Visual Studio Code
    * `brew install visual-studio-code`
    * `code`
    * `~/.dotfiles/install-osx.sh`
* Other software
    * All: `brew install bettertouchtool coconutbattery the-unarchiver vlc`
    * Sierra: `brew install alt-tab disk-inventory-x dozer firefox keepingyouawake libreoffice skype`
    * brew install homebrew/cask/transmission inkscape tunnelblick dbeaver-community keepassxc purevpn arq drawio keka sekey signal sourcetree chromium
* Firefox: see firefox.markdown
* BetterTouchTool
    * install license
    * import preset
    * BTT Remote
        * Disable BTT Remote support
    * Advanced Settings
        * General
            * Disable Allow external BetterTouchTool Scripting
* The Unarchiver
    * Archive Formats
        * Select all
    * Extraction
        * Enable Move the archive to the trash
* Microsoft Teams
    * Try Screen Share
        * System Preferences
            * Security & Privacy
                * Screen Recording
                    * Microsoft Teams: enabled
* rbenv
    * `sudo port install rbenv ruby-build`
    * `rbenv install ${version}`
* Java Development?
    * `sudo port install maven3 openjdk11`
    * `sudo port select --set maven maven3`
* JavaScript Development?
    * `sudo port install npm6 nodejs13 yarn`
* Android SDK
    * `brew cask install android-sdk`
    * `brew cask install android-ndk`
    * `brew cask install intel-haxm`
    * `sdkmanager`
        * if error: `mkdir -p .android && touch ~/.android/repositories.cfg`
    * `sdkmanager "build-tools;28.0.3" "emulator" "patcher;v4" "platform-tools" "platforms;android-28" "tools" "extras;intel;Hardware_Accelerated_Execution_Manager"`
* `update-everything`
* SourceTree
    * `brew install sourcetree`

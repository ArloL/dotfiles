# OS X Setup

* System Update
    * El Capitan: App Store...
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
    * Language & Region
        * English as Primary
        * Region: Germany
    * El Capitan: Keyboard
        * Shortcuts
            * App Shortcuts
                * Terminal
                    * Show Previous Tab: Control+Shift+Tab
                    * Show Next Tab: Control+Tab
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
* El Capitan: Add "USERTrust RSA Certification Authority" root certificate
* MacPorts: https://www.macports.org/
    * `sudo port install nnn p7zip watch wget coreutils findutils mpstats`
* Homebrew: https://brew.sh/
    * `brew install ssh-copy-id`
* No Night Shift?
    * `brew cask install flux`
    * Sunset: Tungsten
    * Bedtime: Candle
* Source Code Pro
    * `brew tap homebrew/cask-fonts`
    * `brew cask install font-source-code-pro`
    * Terminal
        * Preferences
            * Profiles
                * All
                    * Text: Source Code Pro 16pt
* Visual Studio Code
    * `brew cask install visual-studio-code && code`
    * `~/.dotfiles/install-osx.sh`
* `brew cask install bettertouchtool keepingyouawake coconutbattery firefox libreoffice skype the-unarchiver vlc`
* High Sierra: `brew cask install alt-tab disk-inventory-x dozer`
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
* rbenv
    * `sudo port install rbenv ruby-build`
    * `rbenv install ${version}`
* Java Development?
    * `sudo port install maven3 openjdk8`
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
    * `brew cask install sourcetree`

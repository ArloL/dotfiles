# macOS Setup

* System Update
    * El Capitan: App Store...
    * Others: System Preferences -> Software Update
* Safari
    * Settings/Preferences
        * Search
            * Search engine: DuckDuckGo
* System Settings/Preferences
    * General
        * Appearance: Auto
        * Older: Use dark menu bar and Dock: enabled
        * AirDrop & Handoff
            * Allow Handoff between this Mac and your iCloud devices: disabled
    * Desktop & Screen Saver
        * Screen Saver
            * Show screen saver after: 2 Minutes
            * Flurry
                * Options
                    * Colour: Slow cycle
                    * Streams: A little more than few
                    * Thickness: Thin
                    * Speed: Slow
    * Dock & Menu Bar
        * Automatically hide and show the Dock: enabled
        * Show recent applications in Dock: disabled
    * Mission Control
        * Hot Corners…
            * Top Left: Start Screen Saver
            * Top Right: Mission Control
    * Language & Region
        * English as Primary
        * Region: Germany
    * Accessibility
        * Zoom
            * Enable Use scroll gesture with modifier keys to zoom
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
    * Displays
        * Night Shift
            * From 18:00 to 8:00
            * More Warm
    * Sharing
        * Set Computer Name
        * edit local hostname
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
* Touch ID for sudo
    * `sudo nano /etc/pam.d/sudo`
    * `auth sufficient pam_tid.so`
* Xcode
* `sudo hostname -s ${name}`
* `git config --global credential.helper osxkeychain`
* `git clone https://github.com/ArloL/dotfiles.git ~/.dotfiles`
* `~/.dotfiles/install-macos.sh`
* `git push` to setup github credentials
* Mail
    * Settings/Preferences
        * iCloud
            * Mailbox Behaviours
                * Erase deleted messages: never
        * K5D
            * Mailbox Behaviours
                * Erase deleted messages: never
* El Capitan: Add "USERTrust RSA Certification Authority" root certificate
* MacPorts
    * https://www.macports.org/
    * `sudo port install nnn p7zip watch wget coreutils findutils mpstats`
* Homebrew
    * https://brew.sh/
    * El Capitan
        * `brew install git`
    * Older
        * `brew install ssh-copy-id`
* No Night Shift?
    * `brew install homebrew/cask/flux`
    * Sunset: Tungsten
    * Bedtime: Candle
* Source Code Pro
    * `brew install homebrew/cask-fonts/font-source-code-pro`
    * Terminal
        * Settings/Preferences
            * Profiles
                * All
                    * Text: Source Code Pro 16pt
* Visual Studio Code
    * `brew install visual-studio-code`
    * `code`
    * `~/.dotfiles/install-macos.sh`
* Firefox
    * `brew install firefox`
    * see firefox.markdown
* BetterTouchTool
    * `brew install bettertouchtool`
    * install license
    * import preset
    * Settings/Preferences
        * Basic
            * General
                * Launch BetterTouchTool on startup
        * BTT Remote
            * Enable BTT Remote support
        * Advanced Settings
            * Scripting BTT
                * Allow external BetterTouchTool Scripting: disabled
* Inkscape
    * `brew install inkscape`
* Tunnelblick
    * `brew install tunnelblick`
    * Open
    * …
* DBeaver
    * `brew install dbeaver-community`
* KeePassXC
    * `brew install keepassxc`
* Arq
    * `brew install arq`
    * Open
    *   …
* Drawio
    * `brew install drawio`
* Keka
    * `brew install keka`
* Signal
    * `brew install signal`
    * Open
    * Link with Phone
* Chromium
    * `brew install chromium`
* SourceTree
    * `brew install sourcetree`
* Coconut Battery
    * `brew install coconutbattery`
* VLC
    * `brew install vlc`
* Disk Inventory X
    * `brew install disk-inventory-x`
* Hidden Bar
    * `brew install hiddenbar`
    *  Open
* KeepingYouAwake
    * `brew install keepingyouawake`
    * Open
    * Preferences
        * General
            * Start at Login: disabled
        * Activation Duration
            * 5 hours
            * Set Default
        * Battery
            * Deactivate when battery capacity is below: enabled
                * 40%
        * Advanced
            * Allow the display to sleep: enabled
* LibreOffice
    * `brew install libreoffice`
* Skype
    * `brew install skype`
* The Unarchiver
    * `brew install the-unarchiver`
    * Archive Formats
        * Select all
    * Extraction
        * Move the archive to the trash: enabled
* Microsoft Teams
    * Try Screen Share
        * System Preferences
            * Security & Privacy
                * Screen Recording
                    * Microsoft Teams: enabled
* rbenv
    * `brew install rbenv`
    * `rbenv install ${version}`
    * `rbenv global ${version}`
    * `reload`
    * `gem install bundler`
* Java Development?
    * `brew install maven openjdk`
* JavaScript Development?
    * `brew install nodejs yarn`
* Android SDK
    * `brew cask install android-sdk`
    * `brew cask install android-ndk`
    * `brew cask install intel-haxm`
    * `sdkmanager`
        * if error: `mkdir -p .android && touch ~/.android/repositories.cfg`
    * `sdkmanager "build-tools;28.0.3" "emulator" "patcher;v4" "platform-tools" "platforms;android-28" "tools" "extras;intel;Hardware_Accelerated_Execution_Manager"`
* `update-everything`

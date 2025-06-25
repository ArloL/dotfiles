# macOS Setup

* System Update
    * System Settings… -> General -> Software Update
* Safari
    * Settings…
        * Search
            * Search engine: DuckDuckGo
* System Settings…
    * Battery
        * Options…
            * Slightly dim the display on battery: disabled
    * General
        * Language & Region
            * English as Primary
            * Region: Germany
    * Accessibility
        * Zoom
            * Use scroll gesture with modifier keys to zoom: enabled
    * Appearance
        * Appearance: Auto
    * Control Center
        * Now Playing: Don't Show in Menu Bar
        * Spotlight: Don't Show in Menu Bar
    * Desktop & Dock
        * Automatically hide and show the Dock: enabled
        * Show suggested and recent applications in Dock: disabled
        * Tiled windows have margins: disabled
        * Hot Corners…
            * Top Left: Start Screen Saver
            * Top Right: Mission Control
            * Bottom Right: Disabled
            * Bottom Left: Disabled
    * Displays
        * Automaticall adjust brightness: disabled
        * Night Shift
            * Schedule: From 18:00 to 08:00
            * Color temperatur: More Warm
    * Screen Saver
        * Flurry
            * Options
                * Colour: Slow cycle
                * Streams: A little more than few
                * Thickness: Thin
                * Speed: Slow
    * Lock Screen
        * Start Screen Saver when inactive: For 2 minutes
        * Require password after screen saver begins or display is turned off: Immediately
    * Keyboard
        * Keyboard Shortcuts
            * Modifier Keys
                * Caps Lock key: Escape
    * Trackpad
        * Point & Click
            * Tap to click: enabled
        * More Gestures
            * Swipe between full-screen applications: with four fingers
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
    * remove everything except Safari, Mail, Music, Calendar & Notes
* Finder
    * Settings…
        * General
            * New Finder windows show: ${HOME}
        * Sidebar
            * Disable: Recent tags
            * Enable: ${HOME}
    * Change display to columns for all favorites
    * View
        * Show Status Bar
* Mail
    * Settings…
        * Accounts
            * iCloud
                * Mailbox Behaviours
                    * Erase deleted messages: never
            * +
                * Email Address: starlord@k5d.de
                * User Name: starlord@k5d.de
                * Password: …
                * Account Type: IMAP
                * Incoming Mail Server: …
                * Outgoing Mail Server: …
            * K5D
                * Mailbox Behaviours
                    * Erase deleted messages: never
* Calendar
    * Settings…
        * Advanced
            * Show week numbers: enabled
* https://github.com/tomislav/osx-terminal.app-colors-solarized/
    * Download `Solarized Light.terminal`
* Terminal
    * Settings…
        * New tabs open with: Default Profile
        * Profiles
            * … -> Import -> `Solarized Light.terminal`
            * Solarized Light -> Default
* Touch ID for sudo
    * `sudo nano /etc/pam.d/sudo`
    * `auth sufficient pam_tid.so`
* Hostname
    * ```
        yearmonth=$(date +"%y%m")
        sudo hostname -s "Arlos-Mac-${yearmonth}"
        sudo scutil --set HostName "Arlos-Mac-${yearmonth}"
        sudo scutil --set ComputerName "Arlos Mac ${yearmonth}"
        sudo scutil --set LocalHostName "Arlos-Mac-${yearmonth}"
      ```
* `git clone https://github.com/ArloL/dotfiles.git ~/.dotfiles`
* `~/.dotfiles/install-macos.sh`
* `git push` to setup github credentials
* Homebrew
    * https://brew.sh/
* Source Code Pro
    * `brew install --cask font-source-code-pro`
    * Terminal
        * Settings…
            * Profiles
                * All
                    * Text: Source Code Pro 16pt
* Visual Studio Code
    * `brew install visual-studio-code`
    * `~/.dotfiles/install-macos.sh`
    * `code --install-extension morrislaptop.vscode-open-in-sourcetree`
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
* Arq
    * `brew install arq`
    *   …
* Signal
    * `brew install signal`
    * Open
    * Link with Phone
* SourceTree
    * `brew install sourcetree`
* VLC
    * `brew install vlc`
* Disk Inventory X
    * `brew install disk-inventory-x`
* KeepingYouAwake
    * `brew install keepingyouawake`
    * Open
    * Settings…
        * General
            * Activate on Launch: enabled
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
* The Unarchiver
    * `brew install the-unarchiver`
    * Archive Formats
        * Select all
    * Extraction
        * Move the archive to the trash: enabled
* mise
    * `brew install mise`
    * `ln -s ~/.local/share/mise ~/.asdf`
* Java Development?
    * `brew install maven openjdk`
    * `mise use -g java@temurin-21`
    * `sudo mkdir /Library/Java/JavaVirtualMachines/temurin-21`
    * `sudo ln -s ~/.local/share/mise/installs/java/temurin-21/Contents /Library/Java/JavaVirtualMachines/temurin-21/Contents`
    * `sudo mkdir /Library/Java/JavaVirtualMachines/temurin-latest`
    * `sudo ln -s ~/.local/share/mise/installs/java/temurin-latest/Contents /Library/Java/JavaVirtualMachines/temurin-latest/Contents`
* JavaScript Development?
    * `brew install yarn`
    * `mise use --global node@22`
* `update-everything`

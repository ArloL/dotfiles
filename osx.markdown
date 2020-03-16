# OS X Setup

* System Update
* Safari
    * Preferences
        * Search
            * Search engine: Duck Duck Go
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
    * Trackpad
        * Point & Click
            * Tap to click: enabled
        * More Gestures
            * Swipe between full-screen apps: with four fingers
    * Sharing
        * Set Computer Name
        * edit local hostname
* Dock
    * add Applications List
    * add Import to iTunes
    * remove everything except Firefox, Mail, iTunes, Calendar & Notes
* Finder
    * Preferences
        * General
            * New Finder windows show: ${HOME}
            * 
        * Sidebar
            * Disable: All My Files, iCloud Drive, AirDrop, Shared and Tags
            * Enable: ${HOME}
    * Change display to columns for all favorites
* https://github.com/tomislav/osx-terminal.app-colors-solarized/
* Terminal
    * Preferences
        * Profiles
            * Solarized Light as Default
                * Text: Source Code Pro 16pt
* `sudo hostname -s ${name}`
* `git config --global credential.helper osxkeychain`
* `git clone https://github.com/ArloL/dotfiles.git ~/.dotfiles`
* `git push` to setup github credentials
* Homebrew: https://brew.sh/
* No Night Shift? `brew cask install flux`
* Source Code Pro
    * `brew tap homebrew/cask-fonts`
    * `brew cask install font-source-code-pro`
* `brew cask install visual-studio-code && code`
* `~/.dotfiles/install-osx.sh`
* `brew cask install bettertouchtool caffeine coconutbattery firefox libreoffice skype the-unarchiver vlc`
* High Sierra: `brew cask install alt-tab disk-inventory-x dozer`
* `brew cask install macports`: nope
* `sudo port install git p7zip watch wget`
* Firefox: see firefox.markdown
* BetterTouchTool: import preset

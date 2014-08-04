Sublime Text 2/3 Markdown Preview
=================================

Preview and build your markdown files quickly in your web browser from sublime text 2/3. 

You can use builtin [python-markdown][10] parser or use the [github markdown API][5] for the conversion.

**NOTE:** If you choose the GitHub API for conversion (set parser: github in your settings), your code will be sent through https to github for live conversion. You'll have [Github flavored markdown][6], syntax highlighting and EMOJI support for free :heart: :octocat: :gift:. If you make more than 60 calls a day, be sure to set your GitHub API key in the settings :). You can also get most of this in the default Markdown parser with by enabling certain extensions; see "[Parsing Github Flavored Markdown](#parsing-github-flavored-markdown)"" below for more information.

**LINUX users:** If you want to use GitHub API for conversion, you'll need to have a custom Python install that includes python-ssl as its not built in the Sublime Text 2 Linux package. see [@dusteye comment][8]. If you use a custom window manager, also be sure to set a `BROWSER` environment variable. see [@PPvG comments][9]

## Features :

 - Markdown preview using the [Python-markdown][10] or the Github API just choose select the build commands.
 - Syntax highlighting via Pygments. See "[Configuring Pygments](#configuring-pygments)" for more info.
 - Build markdown file using Sublime Text build system. The build parser are config via the `"parser"` config.
 - Browser preview auto reload on save if you have the [ST2 LiveReload plugin][7] installed.
 - Builtin parser : supports `abbr`, `attr_list`, `def_list`, `fenced_code`, `footnotes`, `tables`, `smart_strong`, `smarty`,  `wikilinks`, `meta`, `sane_lists`, `codehilite`, `nl2br`, and `toc` markdown extensions.
 - CSS search path for local and build-in CSS files (always enabled) and/or CSS overriding if you need
 - YAML support thanks to @tommi
 - Clipboard selection and copy to clipboard thanks to @hexatrope
 - MathJax support : \\(\frac{\pi}{2}\\) thanks to @bps10
 - HTML template customisation thanks to @hozaka
 - Embed images as base64 (see [settings][settings] file for more info)
 - Strip out multimarkdown critic marks (see [settings][settings] file for more info)
 - 3rd party extensions for the Python Markdown parser:
 	- **magiclink**: Automatic conversion of http or ftp links to html links.
 	- **delete**: Surround inline text with `~~crossed out~~` to get del tags ~~crossed out~~.
    - **insert**: Surround inline text with `^^underlined^^` to get ins tags <ins>underlined</ins>
 	- **tasklist**: Support for github like tasklists using the following notation: `- [X] Completed Task`.
 	- **githubemoji**: Support for github emojis (`:smile:` --> :smile:). Converts to HTML images that use github's actual emoji assets.
 	- **b64**: Convert and embed images in the HTML as base64 by adding the extension as `b64(base_path=${BASE_PATH})` (recently a global b64 that works on all parsers was added; see [settings][settings] file for more info).
 	- **headeranchor**: Adds support for github style anchor links preceding headers.
 	- **github**: A convenience extension to add: `magiclink`, `delete`, `tasklist`, `githubemoji`, `headeranchor`, and `nl2br` to parse and display GFM in a github-ish way.  It is recommed to pair `github` with `extra` and `codehilite` (with language guessing off) to parse close to github's way.
    - **admonitionicon**: Add font icon to admonition blocks.  Default CSS uses [font awesome](http://fortawesome.github.io/Font-Awesome/)
    - **progressbar**: Create progress bars.  See [Using Progress Bars](#using-progress-bars) for more info.

## Installation :

### Using [Package Control][3] (*Recommended*)

For all Sublime Text 2/3 users we recommend install via [Package Control][3].

1. [Install][11] Package Control if you haven't yet.
2. Use `cmd+shift+P` then `Package Control: Install Package`
3. Look for `Markdown Preview` and install it.

### Manual Install

1. Click the `Preferences > Browse Packages…` menu
2. Browse up a folder and then into the `Installed Packages/` folder
3. Download [zip package][12] rename it to `Markdown Preview.sublime-package` and copy it into the `Installed Packages/` directory
4. Restart Sublime Text

## Usage :

### To preview :

 - optionally select some of your markdown for conversion
 - use `cmd+shift+P` then `Markdown Preview` to show the follow commands (you will be prompted to select which parser you prefer):
	- Markdown Preview: Preview in Browser
	- Markdown Preview: Export HTML in Sublime Text
	- Markdown Preview: Copy to Clipboard
	- Markdown Preview: Open Markdown Cheat sheet
 - or bind some key in your user key binding, using a line like this one:
   `{ "keys": ["alt+m"], "command": "markdown_preview", "args": {"target": "browser", "parser":"markdown"} },` for a specific parser and target or `{ "keys": ["alt+m"], "command": "markdown_preview_select", "args": {"target": "browser"} },` to bring up the quick panel to select enabled parsers for a given target.
 - once converted a first time, the output HTML will be updated on each file save (with LiveReload plugin)

### To build :

 - Just use `Ctrl+B` (Windows/Linux) or `cmd+B` (Mac) to build current file.

### To config :

Using Sublime Text menu: `Preferences`->`Package Settings`->`Markdown Preview`

- `Settings - User` is where you change your settings for Markdown Preview.
- `Settings - Default` is a good reference with detailed descriptions for each setting.

### Configuring Pygments
If you add the codehilite extension manually in the enabled extensions, you can override some of the default settings.

* Turn language guessing *on* or *off* (*on* will highlight fenced blocks even if you don't specify a language)  `codehilite(guess_lang=False)` (True|False).
* Show line numbers: `codehilite(linenums=True)` (True|False).
* Change the higlight theme: `codehilite(pygments_style=emacs)`.
* Inline the CSS: `codehilite(noclasses=True)` (True|False).

See [codehilte page](https://pythonhosted.org/Markdown/extensions/code_hilite.html) for more info.

### Meta Data Support
When the `meta` extension is enabled (https://pythonhosted.org/Markdown/extensions/meta_data.html), the results will be written to the HTML head in the form `<meta name="key" content="value1,value2">`.  `title` is the one exception, and its content will be written to the title tag in the HTML head.

### YAML Frontmatter Support
YAML frontmatter can be stripped out and read when `strip_yaml_front_matter` is set to  `true` in the settings file.  In general the, the fronmatter is handled the same as [meta data](#meta-data-support), but if both exist in a file, the YAML keys will override the `meta` extension keys.  There are a few special keys names that won't be handled as html meta data.

#### Special YAML Key Names
Yaml frontmatter has a few special key names that are used that will not be handled as meta data:

- **basepath**: An absolute path to configure the relative paths for images etc. (for when the markdown is supposed to reference images in a different location.)
- **references**: Can take a file path or an array of file paths for separate markdown files containing references, footnotes, etc.  Can be an absolute path or relative path.  Relative paths first use the source file's directory, and if the file cannot be found, it will use the `basepath` setting.
- **destination**: This is an absolute file path or relative file path for when the markdown is saved to html via the build command or the `Save to HTML` command.  Relative paths first use the source file's directory, and if the file cannot be found, it will use the `basepath` setting.
- **settings**: This is a dictionary where you can override settings that are in the settings file.

#### Example
```yaml
---
    # Builtin values
    references:
        - references.md
        - abbreviations.md
        - footnotes.md

    destination: destination.html

    # Meta Data
    title: Test Page
    author:
        - John Doe
        - Jane Doe

    # Settings overrides
    settings:
        enabled_extensions:
        - extra
        - github
        - toc
        - headerid
        - smarty(smart_quotes=False) # smart quotes interferes with attr_list
        - meta
        - wikilinks
        - admonition
        - codehilite(guess_lang=False,pygments_style=github)
---
```

### Using Progress Bars
Create a progress bar with the following notations:

- Percentage: `[== 35% optional label]`
- Division: `[== 37.5/500 optional label]`

Though progress bars will be recognized inline, they should be displayed as block; they should be used as block items except were not possible (tables etc.).  In general it is best to have an empty line before and after a progress bar.

```
Some text

[== 25% progress bar]

Some more text
```

Default styling is a flat candy-striped  bar, but there is included CSS for animated candy-stripping and a glossy bar.  You can access one or more of these additional stylings by adding the classes when enabling the extension `progressbar(addclasses=candystripe-animate gloss)`.

Also by default, the progress bar extension adds classes to allow for different stylings of percent levels: 0-20%, 21-40%, 41-60%, 61-80%, 80-99%, 100%.  This can be turned off by defining the extension as `progressbar(levelclass=False)`.  When level classes are disabled, the default color is blue.

Additionally, you can change the settings with this inline notation as well `[==50%  MyLabel]{addclasses="additional classes" levelclass="false"}`.

### Parsing Github Flavored Markdown :
Github Flavored Mardown (GFM) is a very popular markdown.  Markdown Preview can actually handle them in a couple of ways: online and offline.

#### Online :
Parsing GFM using the online method requires using the Github API as the parser.  It may also require setting `github_mode` to `gfm` to get things like tasklists to render properly.

#### Offline :
By default almost all extensions are enabled to help with the github feel, but there are some tweaks needed to get the full experience.

GFM does not auto guess language in fenced blocks, but Markdown Preview does this by default.  You can fix this in one of two ways:

1. Disable auto language guessing in the settings file `"guess_language": false,`
2. Or if you are manually defining extensions: `"enabled_extensions": ["codehilite(guess_lang=False,pygments_style=github)"]`


As mentioned earlier, almost all extensions are enabled by default, but as a reference, the minimum extensions that should be enabled are listed below:

```javascript
	"enabled_extensions": [
		"extra",
		"github",
		"codehilite(guess_lang=False,pygments_style=github)"
	]
```

This may be further enhanced in the future.


## Support :

- Any bugs about Markdown Preview please feel free to report [here][issue].
- And you are welcome to fork and submit pullrequests.


## License :

The code is available at github [project][home] under [MIT licence][4].

 [home]: https://github.com/revolunet/sublimetext-markdown-preview
 [3]: https://sublime.wbond.net/
 [4]: http://revolunet.mit-license.org
 [5]: http://developer.github.com/v3/markdown
 [6]: http://github.github.com/github-flavored-markdown/
 [7]: https://github.com/dz0ny/LiveReload-sublimetext2
 [8]: https://github.com/revolunet/sublimetext-markdown-preview/issues/27#issuecomment-11772098
 [9]: https://github.com/revolunet/sublimetext-markdown-preview/issues/78#issuecomment-15644727
 [10]: https://github.com/waylan/Python-Markdown
 [11]: https://sublime.wbond.net/installation
 [12]: https://github.com/revolunet/sublimetext-markdown-preview/archive/master.zip
 [issue]: https://github.com/revolunet/sublimetext-markdown-preview/issues
 [settings]: https://github.com/revolunet/sublimetext-markdown-preview/blob/master/MarkdownPreview.sublime-settings

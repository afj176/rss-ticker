# RSS Ticker package [![Build Status](https://travis-ci.org/afj176/rss-ticker.svg?branch=master)](https://travis-ci.org/afj176/rss-ticker)

![RSS Ticker ScreenShot](https://raw.github.com/afj176/rss-ticker/master/images/screenshot.gif)

##Installing

1. Go to `Atom -> Preferences...`
2. Then select the `Packages` tab
3. Enter `rss-ticker` in the search box

#### Using apm

```sh
$ apm install rss-ticker
```

#### Install using Git

Alternatively, if you are a git user, you can install the theme and keep up to date by cloning the repo directly into your `~/.atom/packages` directory.

```sh
$ git clone https://github.com/afj176/rss-ticker/ ~/.atom/packages/rss-ticker
```

#### Download Manually

1. Download the files using the [GitHub .zip download](https://github.com/afj176/rss-ticker/archive/master.zip) option and unzip them
3. Move the `rss-ticker` folder to `~/.atom/packages`



## Usage

Display your favorite rss feed in your status bar.

#### Deactivating/Activating the plugin

Keyboard shortcut `ctrl-shift-.` will toggle the RSS Ticker.

#### Plugin settings page

To access the RSS Ticker Settings:
1. Go to `Atom -> Preferences...` or `cmd-,`
2. In the `Filter Packages` type `rss-ticker`

![Settings](https://raw.github.com/afj176/rss-ticker/master/images/settings.png)

RSS Ticker has two settings that can be edited:
1. feed | default:`http://rss.cnn.com/rss/edition_world.rss?format=xml`
2. icon | default:`atom://rss-ticker/images/Cnn.svg`



### Commands

The following commands are available for users to keymap.

* `rss-ticker:toggle` - Toggle the status bar entry

## Coming Soon

* Tests

Feel free to open an issue to discuss potential features to add or improve.

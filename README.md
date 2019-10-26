# Muninn

Take screenshots of websites

>_Huginn ok Muninn_<br>
_fljúga hverjan dag_<br>
_Jörmungrund yfir;_<br>
_óumk ek of Hugin,_<br>
_at hann aftr né komi-t,_<br>
_þó sjámk meir of Munin._

## Setup

#### 1. Download and install `rvm` or `rbenv`.

Installing `rbenv` on a macOS environment:

```bash
brew install rbenv
rbenv init
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
rbenv install 2.6.5
```

You can confirm the install is working by using the `rbenv-doctor` script:
`curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash`

Debugging commands:

```bash
gem env #List rubygems version and info
rbenv version #List rbenv version number and path
rbenv install -l #List versions of Ruby you can install
rbenv global 2.6.5 #Use version 2.6.5 as your main ruby version
```

#### 2. Download and install a web driver gem

We can use either `Selenium-webdriver` or `Chrome-webdriver`.

Installing `Selenium-webdriver`:

`gem install selenium-webdriver`

#### 3. Downloading browser drivers

To use Selenium with Firefox, we need the [Mozilla geckodriver](https://developer.mozilla.org/en-US/docs/Web/WebDriver) in our PATH.

Download the driver from here: https://github.com/mozilla/geckodriver/releases

Unzip, untar, and add it to your PATH:
`export PATH=$PATH:~/Tools`

#### 4. Taking a screenshot

Using `Selenium-webdriver`:

```ruby
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :firefox
driver.navigate.to 'https://mu.gl'
driver.save_screenshot('screenshot.png')
driver.quit
```


# Muninn

Take screenshots of websites

>_Huginn ok Muninn_<br>
_fljúga hverjan dag_<br>
_Jörmungrund yfir;_<br>
_óumk ek of Hugin,_<br>
_at hann aftr né komi-t,_<br>
_þó sjámk meir of Munin._

## Setup

### 1. Download and install `rvm` or `rbenv`.

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

### 2. Download and install dependencies.

We first need a web driver library to interact with a browser.

We can use either [Selenium-webdriver](https://github.com/SeleniumHQ/selenium) or [ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/).

Installing `Selenium-webdriver`:

`gem install selenium-webdriver`

We then need a WHOIS library to get domain registration information. We'll use the [Ruby WHOIS](https://github.com/weppos/whois) gem:

`gem install whois`

### 3. Download browser drivers.

To use Selenium with Firefox, we need the [Mozilla geckodriver](https://developer.mozilla.org/en-US/docs/Web/WebDriver) in our PATH.

Download the driver from here: https://github.com/mozilla/geckodriver/releases

Unzip, untar, and add it to your PATH:
`export PATH=$PATH:~/Tools`

### 4. Take a screenshot.

Using `Selenium-webdriver` in Ruby:

```ruby
require 'selenium-webdriver'

driver = Selenium::WebDriver.for :firefox
driver.navigate.to 'https://mu.gl'
driver.save_screenshot('screenshot.png')
driver.quit
```
### 5. Get domain WHOIS info.

```ruby
require 'whois'

# Domain WHOIS
whois = Whois::Client.new
whois.lookup("mu.gl")
# => #<Whois::Record>
```

### 6. Configuring Rails

**1. Create a new rails app:**
`rails new appname`

**2. To properly install Yarn:**

https://yarnpkg.com/lang/en/docs/install/#debian-stable
contains the following instructions:

```bash
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt update && sudo apt install yarn
```

**3. Configure webpacker**

`rails webpacker:install`

**4. Launch server**

Test everything is working:
`rails s`

**5. Add a route to the landing/index page**

Generate the controller:
`rails generate controller landing index`

Include new page in the routing file as the app's root:
in `config/routes.rb` add the following line:
`root 'landing#index'`

**6. Edit landing page**

`vim app/views/landing/index.html.erb`



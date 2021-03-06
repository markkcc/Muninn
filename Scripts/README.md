# Documentation

Various setup tips included below.

## Setup

### 1. Download and install `rvm` or `rbenv`.

On Linux, use [rbenv-installer](https://github.com/rbenv/rbenv-installer#rbenv-installer).

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

Or do it with this one-liner:
`mkdir ~/Tools; curl -L https://github.com$(curl -sL https://github.com/mozilla/geckodriver/releases/latest | grep -i 'linux64.tar.gz\"' | cut -d \" -f 2) | tar -C ~/Tools -xzf - && export PATH=$PATH:~/Tools`

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

Local dependencies:
```
sudo apt install postgresql libpq-dev
```

If deploying on Heroku, you need to switch to Postgres.
```
1. Install postgresql
2. Create user and set a password
3. edit config/database.yml
4. rails db:create
```

Helpful envars:
```
export PATH="$HOME/.rbenv/bin:$PATH"
export PATH=$PATH:~/Tools
export DATABASE_URL=postgres://$(whoami)
eval "$(rbenv init -)"

#Secrets
export VIRUSTOTAL_API_KEY=xxxxxxxxxxxxxxxx
export MUNINN_DATABASE_PASSWORD_PROD=xxxxx
export MUNINN_DATABASE_PASSWORD_DEV=xxxxxx
```

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

## Heroku Improvements

### Excluding resources with `.slugignore`

Similar to a `.gitignore`, Heroku supports a `.slugignore` file. Any files or folders listed in there will be excluded when building a "Heroku slug", i.e. during deployment.

### Buildpacks

Allow you to run your own bash scripts before deploying your app. Used for downloading various binaries your app may require.

**Adding an existing Buildpack:**

```
heroku buildpacks:add --index 1 http://github.com/path_to/buildpack -a herokuappname
```

You can find a number of useful Buildpacks to use in your app.

**Creating your own Buildpack:**

Buildpacks are essentialls three bash scripts stored in a `bin` directory:

- `detect`: This is run to determine if we should run the buildpack. If it returns successfully (`exit 0`), the buildpack runs. Not important if you want the buildpack to always run.
- `compile`: This script takes 2 arguments, *BUILD_DIR* (app root) and *CACHE_DIR* (persists between deploys).
- `release`: Adds configs, envars etc.

Sample compile script for arbitrary binary file:

```
# Change into the build directory
cd $1

# Download the needed archived binary (-O) silently (-s)
curl https://link.to/binary.tgz -s -O

# Extract binary from archive
mkdir -p vendor/binary

# untar the binary to the directory we want
tar -C vendor/binary -xvf binary.tgz
```

[Note](https://devcenter.heroku.com/changelog-items/1138): Heroku default PATH variable now excludes all entries within `/app` during builds

### Additional Resources on Buildpacks

- Heroku: [Buildpacks Article](https://devcenter.heroku.com/articles/buildpacks)
- Heroku: [Hacking Buildpacks](https://blog.heroku.com/hacking-buildpacks) (2012)
- Github: [Null Buildpack](https://github.com/ryandotsmith/null-buildpack) (Fork to build your own)
- Blog: [Run Anything on Heroku with Custom Buildpacks](https://www.petekeen.net/introduction-to-heroku-buildpacks)

### Installing the [Sqreen](https://elements.heroku.com/addons/sqreen) addon on Heroku for Rails

1. Add it to your app from your Heroku dashboard, then open the Sqreen addon
2. `echo "gem 'sqreen', '>= 1.16'" >> Gemfile`
3. `bundle install`
4. Set Sqreen's token (provided by their addon dashboard), as an envar in Heroku
`heroku config:set SQREEN_TOKEN=xxxxxxxxxxxxxxxxxxxxxxx -a appnamehere`


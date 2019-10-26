# Muninn

Take screenshots of websites

> _Huginn ok Muninn_
> _fljúga hverjan dag_
> _Jörmungrund yfir;_
> _óumk ek of Hugin,_
> _at hann aftr né komi-t,_
> _þó sjámk meir of Munin._

## Setup

1. Download and install `rvm` or `rbenv`.

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


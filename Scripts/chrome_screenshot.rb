require "selenium-webdriver"

global_timeout = 12 #seconds, max time to load
lookup_target = "https://expired.badssl.com/"

capabilities = ""

options = Selenium::WebDriver::Chrome::Options.new
options.add_argument "--window-size=800x800"
options.add_argument "--headless"
options.add_argument "--disable-gpu"
options.add_argument "--disable-speech-api"
options.add_argument "--disable-sync" #Disable Google account syncing
options.add_argument "--disable-translate"
options.add_argument "--disable-web-security" #Don't care about SOP
options.add_argument "--hide-scrollbars"
options.add_argument "--ignore-certificate-errors"
options.add_argument "--no-default-browser-check"
options.add_argument "--no-pings" #"Don't send hyperlink auditing pings"
options.add_argument "--fast"
# --no-sandbox
# --no-startup-window

driver = Selenium::WebDriver.for :chrome, options: options

driver.manage.timeouts.implicit_wait = global_timeout
driver.manage.timeouts.script_timeout = global_timeout
driver.manage.timeouts.page_load = global_timeout

driver.navigate.to(lookup_target)
sleep(4) #wait for dynamic content to load
driver.save_screenshot('screenshot.png')

driver.quit

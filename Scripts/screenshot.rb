require 'selenium-webdriver'

if ARGV.length != 1
  puts "Please specify target in an argument"
  exit
end


driver = Selenium::WebDriver.for :firefox
driver.navigate.to ARGV[0]
driver.save_screenshot('screenshot.png')
driver.quit

require 'selenium-webdriver'

driver = Selenium::WebDriver.for :firefox
driver.navigate.to 'https://mu.gl'
driver.save_screenshot('screenshot.png')
driver.quit

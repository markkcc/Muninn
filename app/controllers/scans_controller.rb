class ScansController < ApplicationController
  def new
  end

  def index
    redirect_to root_path
  end

  def create
    scan = params.fetch(:scan, "")
    #@scan.save
    #redirect_to @scan
    
    @lookup_target = validate_url(scan["URL"])

    if @lookup_target == ""
      @virustotaldata = "404"
      @whoisdata = "404"
      @screenshot = ""
    end
    @whoisdata = get_whoisdata(@lookup_target) unless params[:scan]["whois_enabled"] != "1" or @lookup_target == ""
    @virustotaldata = get_virustotaldata(@lookup_target) unless params[:scan]["virustotal_enabled"] != "1" or @lookup_target == ""
    if @whoisdata == "404" and @virustotaldata == "404"
      # If both failed, not worth trying.
      @screenshot = ""
    else
      @screenshot = get_screenshot(@lookup_target) unless scan["screenshot_enabled"] != "1" or @lookup_target == ""
    end
  end

  def validate_url(url)
    if url.length >= 2100
      return "" #Muninn is unamused by absurd requests.
    end
    if url["127.0.0.1"] or url["//localhost"] #reject
      return "" #Muninn introspects...
    end
    #Muninn is uninterested in mundane requests.
    url = "https://" + url unless url.start_with?("http://") or url.start_with?("https://")
    return URI.escape(url).to_s unless url == "https://" #default value, return empty
    return ""
  end

  def get_whoisdata(lookup_target)
    begin
      whois_results = Whois.whois(PublicSuffix.domain(URI(lookup_target).host, ignore_private: true)).to_s
    rescue Whois::ServerNotFound => snf
      whois_results = "404"
    rescue URI::InvalidURIError => iue
      whois_results = "404"
    rescue Whois::ConnectionError => ce
      whois_results = "404"
    end
    return whois_results
  end

  def get_virustotaldata(url)
    begin
      vtdata = VirusTotal::API.new.url.get(url)
    rescue VirusTotal::NotFoundError => nfe
      begin
        vtdata = VirusTotal::API.new.url.get(URI(url).host)
      rescue VirusTotal::NotFoundError => nfe_fatal
        vtdata = "404"
      rescue URI::InvalidURIError => iue
        vtdata = "404"
      end
    end
    return vtdata
  end

  def get_screenshot(lookup_target)
    global_timeout = 15 #seconds, max time to load
    screenshot_base64 = ""
    if params[:scan]["screenshot_enabled"] == "1"
      begin
        options = Selenium::WebDriver::Chrome::Options.new
        options.add_argument "--window-size=1280x1024"
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

        driver = Selenium::WebDriver.for :chrome, options: options
        
        driver.manage.timeouts.implicit_wait = global_timeout
        driver.manage.timeouts.script_timeout = global_timeout
        driver.manage.timeouts.page_load = global_timeout
        
        driver.navigate.to @lookup_target
        sleep(2.5) #wait for dynamic content to load
        screenshot_base64 = driver.screenshot_as(:base64)
        
        driver.quit
      rescue Selenium::WebDriver::Error::TimeoutError => toe
        screenshot_base64 = ""
        driver.quit unless driver.nil?
      #rescue Selenium::WebDriver::Error::UnknownError => ue
      #  screenshot_base64 = ""
      #  driver.quit unless driver.nil?
      #rescue Selenium::WebDriver::Error::WebDriverError => wde
      #  screenshot_base64 = ""
      #  driver.quit unless driver.nil?
      end
    end
    return screenshot_base64
  end
end

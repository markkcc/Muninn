class ScansController < ApplicationController
  def new
  end

  def create
    scan = params[:scan]
    #@scan.save
    #redirect_to @scan
    
    @lookup_target = validate_url(scan["URL"])

    @whoisdata = get_whoisdata(@lookup_target) unless params[:scan]["whois_enabled"] != "1"
    @virustotaldata = get_virustotaldata(@lookup_target) unless params[:scan]["virustotal_enabled"] != "1"
    if @whoisdata == "404" and @virustotaldata == "404"
      # If both failed, not worth trying.
      @screenshot = ""
    else
      @screenshot = get_screenshot(@lookup_target) unless scan["screenshot_enabled"] != "1"
    end
  end

  def validate_url(url)
    if url["127.0.0.1"] or url["//localhost"] #reject
      raise "localhost" #Muninn introspects...
    end
    #Muninn is uninterested in mundane requests.
    url = "https://" + url unless url.start_with?("http://") or url.start_with?("https://")
    return URI.escape(url).to_s
  end

  def get_whoisdata(lookup_target)
    begin
      whois_results = Whois.whois(PublicSuffix.domain(URI(lookup_target).host, ignore_private: true)).to_s
    rescue Whois::ServerNotFound => snf
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
      end
    end
    return vtdata
  end

  def get_screenshot(lookup_target)
    global_timeout = 12 #seconds, max time to load
    screenshot_base64 = ""
    if params[:scan]["screenshot_enabled"] == "1"
      begin
        capabilities = Selenium::WebDriver::Remote::Capabilities.firefox(accept_insecure_certs: true)
        driver = Selenium::WebDriver.for :firefox, desired_capabilities: capabilities
        driver.manage.timeouts.implicit_wait = global_timeout
        driver.manage.timeouts.script_timeout = global_timeout
        driver.manage.timeouts.page_load = global_timeout
        driver.navigate.to @lookup_target
        sleep(2.5)
        screenshot_base64 = driver.screenshot_as(:base64)
        driver.quit
      rescue Selenium::WebDriver::Error::TimeoutError => toe
        screenshot_base64 = ""
        driver.quit
      rescue Selenium::WebDriver::Error::UnknownError => ue
        screenshot_base64 = ""
        driver.quit
      end
    end
    return screenshot_base64
  end
end
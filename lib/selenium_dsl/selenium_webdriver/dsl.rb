require 'selenium/webdriver'
require 'selenium_dsl/proxy'
require 'selenium_dsl/selenium_webdriver/script'

module SeleniumDSL::SeleniumWebdriver
  class DSL
    attr_reader :script, :driver

    attr_writer :timeout_in_seconds

    def initialize(selenium_host, selenium_port, browser, capabilities={})
      @driver = get_driver(browser.to_sym, false, selenium_host, selenium_port.to_i)

      @driver.capabilities.merge(capabilities) unless capabilities.empty?

      @script = SeleniumDSL::SeleniumWebdriver::Script.new @driver
    end

    def timeout_in_seconds= timeout_in_seconds
      @driver.manage.timeouts.implicit_wait = timeout_in_seconds.to_i
    end

    def start
    end

    def stop
      @driver.quit
    end

    def selenium_webdriver(&block)
      @script.instance_eval(&block)

      @script
    end

    private

    def get_driver browser, remote=false, host="localhost", port=4444
      if remote
        case browser
          when :firefox
            #caps = Selenium::WebDriver::Remote::Capabilities.firefox(:proxy => Selenium::WebDriver::Proxy.new(:http => "myproxyaddress:8080"))

            Selenium::WebDriver.for(:remote, :desired_capabilities => browser, :url => "http://#{host}:#{port}/wd/hub/")
          when :chrome
            Selenium::WebDriver.for(:remote, :desired_capabilities => browser, :url => "http://#{host}:#{port}/wd/hub/")
          when :ie
            caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer
            caps['enablePersistentHover'] = false

            Selenium::WebDriver.for(:remote, :desired_capabilities => caps, :url => "http://#{host}:#{port}/wd/hub/")
        end
      else
        case browser
          when :firefox
            profile = Selenium::WebDriver::Firefox::Profile.new
            #profile.add_extension("/path/to/firebug.xpi")

            Selenium::WebDriver.for :firefox, :profile => profile
          when :chrome
            profile = Selenium::WebDriver::Chrome::Profile.new
            profile['download.prompt_for_download'] = false
            profile['download.default_directory'] = "/path/to/dir"

            switches = %w[--ignore-certificate-errors --disable-popup-blocking --disable-translate]

            Selenium::WebDriver.for :chrome, :profile => profile, :switches => switches
          when :ie
            Selenium::WebDriver.for :ie
          else
            Selenium::WebDriver.for :firefox
        end
      end
    end
  end

end

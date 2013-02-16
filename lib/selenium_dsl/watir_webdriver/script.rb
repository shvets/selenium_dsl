require 'watir-webdriver'
require 'selenium_dsl/proxy'

module SeleniumDSL::WatirWebdriver
  class Script < SeleniumDSL::Proxy
    attr_reader :driver

    attr_accessor :timeout_in_seconds

    def initialize driver
      super driver, [:open, :select, :type]

      @driver = driver

      @timeout_in_seconds = 60
    end

    #def wait_until_enabled(id, timeout=10)
    #  wait = ::Selenium::WebDriver::Wait.new(:timeout => timeout) # seconds
    #  wait.until {
    #    driver.find_element(:id, id)
    #  }
    #end

  end
end

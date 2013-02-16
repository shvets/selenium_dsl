require 'selenium/webdriver'
require 'selenium_dsl/proxy'

module SeleniumDSL::SeleniumWebdriver
  class Script < SeleniumDSL::Proxy
    attr_reader :driver

    attr_accessor :timeout_in_seconds

    def initialize driver
      super driver, [:open, :select, :type]

      @driver = driver

      @timeout_in_seconds = 60
    end

    def wait_until_enabled(type, query, timeout=10)
      wait = ::Selenium::WebDriver::Wait.new(:timeout => timeout) # seconds
      wait.until {
        driver.find_element(type, query)
      }
    end

    def is_text_present type, query, value
      !!(find_element(type, query).text =~ /#{value}/)
    end

    def click type, query
      find_element(type, query).click
    end

    def select_box type, query, value
      select_box = find_element(type, query)

      options = select_box.find_elements(:tag_name => "option")

      options.each do |option_field|
        if option_field.text == value
          option_field.click
          break
        end
      end
    end

  end
end

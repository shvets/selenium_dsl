require 'selenium/webdriver'
require 'selenium_dsl/proxy'
require 'selenium_dsl/selenium_helper'
require 'selenium_dsl/selenium_webdriver/script'

module SeleniumDSL::SeleniumWebdriver
  class DSL
    include SeleniumHelper

    attr_reader :script, :driver

    attr_writer :timeout_in_seconds

    def initialize(selenium_host, selenium_port, browser, capabilities={})
      @driver = Selenium::WebDriver.for(:remote, :url => construct_selenium_url(selenium_host, selenium_port),
                                        :desired_capabilities => browser.to_sym)

      @driver.capabilities.merge(capabilities) unless capabilities.empty?

      @script = SeleniumDSL::SeleniumWebdriver::Script.new @driver
    end

    def timeout_in_seconds= timeout_in_seconds
      #@driver.manage.timeouts.implicit_wait = timeout_in_seconds.to_i
      @script.timeout_in_seconds = timeout_in_seconds.to_i
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
  end

end

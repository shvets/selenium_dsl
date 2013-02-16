require "selenium/client"
require 'selenium_dsl/proxy'
require 'selenium_dsl/selenium_helper'
require 'selenium_dsl/selenium_client/script'

module SeleniumDSL::SeleniumClient
  class DSL
    include SeleniumHelper

    attr_reader :script, :driver

    def initialize(selenium_host, selenium_port, browser, webapp_url, capabilities={})
      @selenium = Selenium::Client::Driver.new \
      :host => selenium_host,
      :port => selenium_port.to_i,
      :browser => "*webdriver",
      :url => webapp_url

      @driver = Selenium::WebDriver.for :remote,
                                        :url => construct_selenium_url(selenium_host, selenium_port),
                                        :desired_capabilities => browser.to_sym

      @driver.capabilities.merge(capabilities) unless capabilities.empty?

      @script = SeleniumDSL::SeleniumClient::Script.new @selenium, @driver
    end

    def timeout_in_seconds= timeout_in_seconds
      @script.timeout_in_seconds = timeout_in_seconds
    end

    def start
      #@selenium.start_new_browser_session
      @selenium.start :driver => @driver
    end

    def stop
      #@selenium.close_current_browser_session
      @driver.quit
      @selenium.stop
    end

    def selenium_client(&block)
      @script.instance_eval(&block)

      @script
    end

  end
end

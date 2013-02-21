require 'capybara'
require 'capybara/dsl'
require 'capybara/webkit'
require 'selenium_dsl/proxy'
require 'selenium_dsl/selenium_helper'
require 'selenium_dsl/capybara/script'

module SeleniumDSL::Capybara
  class DSL
    include SeleniumHelper

    attr_reader :script, :driver

    attr_writer :timeout_in_seconds

    def initialize(selenium_host, selenium_port, browser, webapp_url, requested_driver, capabilities={})
      Capybara.run_server = false
      Capybara.app_host = webapp_url

      if requested_driver == :selenium
        requested_driver = "selenium_#{browser}".to_sym

        Capybara.register_driver requested_driver do |app|
          client = Selenium::WebDriver::Remote::Http::Default.new
          client.timeout = 120
          #caps = Selenium::WebDriver::Remote::Capabilities.firefox

          Capybara::Selenium::Driver.new(app, {:url => construct_selenium_url(selenium_host, selenium_port),
                                               :browser => :remote, :desired_capabilities => browser.to_sym,
                                              :http_client => client})
        end
      end

      Capybara.javascript_driver = requested_driver.to_sym
      Capybara.current_driver = requested_driver.to_sym

      @session = Capybara::Session.new(requested_driver.to_sym, nil)

      @script = SeleniumDSL::Capybara::Script.new @session
    end

    def timeout_in_seconds= timeout_in_seconds
      Capybara.default_wait_time = timeout_in_seconds.to_i
    end

    def start
    end

    def stop
      @session.reset!

      Capybara.use_default_driver
      Capybara.app_host = nil

      #Capybara::Driver::Webkit::Browser

      #@session.driver.browser.close
    end

    def capybara(&block)
      @script.instance_eval(&block)

      @script
    end

  end

end
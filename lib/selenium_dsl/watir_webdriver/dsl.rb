require 'watir-webdriver'
require 'selenium_dsl/proxy'
require 'selenium_dsl/watir_webdriver/script'

module SeleniumDSL::WatirWebdriver
  class DSL
    attr_reader :script, :driver

    attr_writer :timeout_in_seconds

    def initialize(browser, capabilities={})
      @driver = Watir::Browser.new browser.to_sym

      @driver.capabilities.merge(capabilities) unless capabilities.empty?

      @script = SeleniumDSL::WatirWebdriver::Script.new @driver
    end

    def timeout_in_seconds= timeout_in_seconds
      #@driver.manage.timeouts.implicit_wait = timeout_in_seconds.to_i
    end

    def start
    end

    def stop
      @driver.close
    end

    def watir_webdriver(&block)
      @script.instance_eval(&block)

      @script
    end

  end

end

require 'capybara'
require 'capybara/dsl'
require 'selenium_dsl/proxy'
require 'selenium_dsl/capybara/script'

module SeleniumDSL::Capybara
  class DSL
    attr_reader :script, :driver

    attr_writer :timeout_in_seconds

    def initialize(selenium_host, selenium_port, browser, webapp_url, default_driver, capabilities={})
      Capybara.default_driver = default_driver

      Capybara.run_server = false
      Capybara.default_wait_time = 5
      Capybara.app_host = webapp_url

      @driver = Capybara::Session.new(default_driver, nil)

      @script = SeleniumDSL::Capybara::Script.new @driver
    end

    def timeout_in_seconds= timeout_in_seconds
      #@driver.manage.timeouts.implicit_wait = timeout_in_seconds.to_i
    end

    def start
    end

    def stop
      Capybara.reset_sessions!
      Capybara.use_default_driver
    end

    def capybara(&block)
      @script.instance_eval(&block)

      @script
    end

  end

end

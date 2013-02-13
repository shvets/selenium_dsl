require "selenium/client"
require 'selenium_dsl/proxy'

module SeleniumDSL
  module DSL
    def init_selenium(host, port, browser, url, timeout_in_seconds)
      @selenium_driver = Selenium::Client::Driver.new \
      :host => host,
      :port => port,
      :browser => browser,
      :url => url,
      :timeout_in_seconds => timeout_in_seconds

      @script = Script.new @selenium_driver, timeout_in_seconds
    end

    def start_new_session
      @selenium_driver.start_new_browser_session
    end

    def close_session
      @selenium_driver.close_current_browser_session
    end

    def selenium(&block)
      @script.instance_eval(&block)

      @script
    end
  end
end

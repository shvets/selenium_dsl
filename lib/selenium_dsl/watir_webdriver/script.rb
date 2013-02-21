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

  end
end

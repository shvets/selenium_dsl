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

    def condition block
      lambda do |type, query|
        element = find_element(type, query)

        block.call(element)
      end
    end

    def generic_condition block
      lambda do
        block.call()
      end
    end

    def wait_for_condition(*params)
      if params.size == 1
        condition = *params

        wait = ::Selenium::WebDriver::Wait.new(:timeout => @timeout_in_seconds) # seconds

        wait.until { condition.call() }
      elsif params.size == 3
        type, query, condition = *params

        wait = ::Selenium::WebDriver::Wait.new(:timeout => @timeout_in_seconds) # seconds

        wait.until { condition.call(type, query) }
      end
    end

    def is_text_present type, query, value
      !!(find_element(type, query).text =~ /#{value}/i)
    end

    def click type, query
      find_element(type, query).click
    end

    def select_box type, query, value
      select_box = find_element(type, query)

      options = select_box.find_elements(:tag_name => "option")

      option = nil

      if value.kind_of? ::Fixnum # get n-th element
        option = options[value]
      else
        options.each do |current_option|
          if current_option.text == value
            option = current_option
            break
          end
        end
      end

      option.click if option
    end

    def input type, query, value
      find_element(type, query).send_keys(value)
    end
  end
end

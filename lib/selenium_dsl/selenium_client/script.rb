require 'selenium_dsl/proxy'

module SeleniumDSL::SeleniumClient
  class Script < SeleniumDSL::Proxy
    attr_reader :selenium, :driver

    attr_accessor :timeout_in_seconds

    def initialize selenium, driver
      super selenium, [:open, :select, :type]

      @selenium = selenium
      @driver = driver
      @timeout_in_seconds = 60
    end

    def click locator, *params
      selenium.click locator, *params

      if params.size > 0
        selenium.wait_for_condition "selenium.browserbot.getCurrentWindow().jQuery.active == 0" if params[0][:ajax]

        selenium.wait_for_page_to_load @timeout_in_seconds if params[0][:wait]
      end
    end

# def select_value value, element, prefix
# selenium.select "#{prefix}_#{element}", "value=#{value}"
# end

    def check_select value, element, prefix
      selenium.click full_input_name(prefix, element)
    end

    def full_input_name(prefix, input_name)
      prefix ? "#{prefix}_#{input_name}" : input_name
    end

    def session_id
      /session_id=(\w+)/.match(selenium.get_cookie)[1]
    end

# def enter value, element, prefix
# selenium.type "#{prefix}_#{element}", value
# end

    def radio_select value, element, prefix
      if prefix.nil?
        selenium.click "id=#{value}"
      else
        selenium.click "#{prefix}_#{element}_#{value}"
      end
    end

    def go_back
      selenium.go_back
    end

# def new_session(path)
# open(path)
# end

# def goto path
# selenium.open path
# end

# def reset_session
# selenium.delete_cookie('_proteus_session', '/')
# selenium.delete_cookie('login', '/')
# end

# def select_value value, element, prefix
# selenium.select "#{prefix}_#{element}", "value=#{value}"
# end

    def wait_for_text value, element_id, timeout=10000
      script = <<-EOF
var element = #{selenium_get_element_by_id(element_id)};
var included = false;
if (element.value == '#{value}') included = true;
included;
      EOF
      selenium.wait_for_condition(script, timeout)
    end

    def wait_for_option(value, element, prefix, timeout=30000)
      option_list = "#{prefix}_#{element}"
      script = <<-EOF
var option_list = #{selenium_get_element_by_id(option_list)};
var included = false;

if( option_list != null && option_list.length > 0 ) {
for( x=0; x < option_list.length; x++ ) {
if( option_list[x] != null ) {
if( option_list[x].value == '#{value}' ) included = true;
}
}
}

included;
      EOF

      selenium.wait_for_condition(script, timeout)
    end

    def wait_until_enabled( element_id, timeout=10000)
      selenium.wait_for_condition(
          "selenium.browserbot.getCurrentWindow()." +
              "document.getElementById('#{element_id}').disabled == false;",
          timeout
      )
    end

# def assert_title(expected_value)
# assert_equal expected_value, selenium.get_title, "Expected title to be: '#{expected_value}' but was '#{selenium.get_title}'"
# end
#
# def assert_contains text, message=nil
# assert(contains?(text), message.nil? ? "Expected to find text '#{text}'" : message)
# end
#
# def assert_not_contains text
# assert !contains?(text), "Expected not to find text '#{text}'"
# end
#
# def assert_value(expected_value, element)
# assert_equal expected_value, selenium.get_value(element)
# end

    def contains? text
      /#{text}/ =~ selenium.get_html_source
    end

# def assert_selected value, element, prefix
# id = prefix.blank? ? "#{element}" : "#{prefix}[#{element}]"
# assert_equal value, selenium.get_selected_value("#{id}")
# end

    def match_element id
      Regexp.new("<([^>]*)(id *= *['\"]?#{id}['\"]?)([^>]*)>", Regexp::IGNORECASE).match(selenium.get_html_source)
    end

    def visible? element
      element_tag = element.to_a[0]

      return false if element_tag.nil?

      Regexp.new(".*display:none.*").match(element_tag.gsub(' ', '').downcase).nil?
    end

# def assert_shown id
# element = match_element(id)
#
# assert(!element.nil? && visible?(element))
# end
#
# def assert_hidden id
# element = match_element(id)
#
# assert(!element.nil? && !visible?(element))
# end
#
# def assert_exists id
# assert_not_nil(match_element(id))
# end
#
# def assert_does_not_exist id
# assert_nil(match_element(id))
# end

    protected

    def selenium_get_element_by_id(id)
      "#{selenium_window}.document.getElementById('#{id}')"
    end

    def selenium_window
      "selenium.browserbot.getCurrentWindow()"
    end

    def remove_element(id)
      wait_for_condition "#{selenium_get_element_by_id(id)}.remove()", 10000
    end

    def wait_for_element(id)
      wait_for_condition "#{selenium_get_element_by_id(id)} != null", 10000
    end

    def response_body
      selenium.get_html_source
    end

    def text_for id
      selenium.get_text(id)
    end

  end
end

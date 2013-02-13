# access_webapp_spec.rb

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "access wikipedia" do

  it_should_behave_like :SeleniumTest do
    before :all do
      config = load_configuration

      puts "Application: #{config['webapp_url']}"
      puts "Selenium: #{config['selenium_server_address']}:#{config['selenium_server_port']}"

      init_selenium(config['selenium_server_address'], config['selenium_server_port'].to_i,
                    config['selenium_browser_key'], config['webapp_url'], config['timeout_in_seconds'])
    end

    it "should submit the request" do
      selenium do
        open "/"

        is_text_present("The Free Encyclopedia").should be_true

        type "searchInput", "iphone"

        click "go", :wait => true

        is_text_present("iPhone").should be_true
      end

    end
  end

  private

  def load_configuration
    config = {
        'application_address' => 'www.wikipedia.org',
        'application_port' => '80',
        'application_name' => '',
        'selenium_server_address' => 'localhost',
        'selenium_server_port' => '4444',
        'selenium_browser_key' => '*firefox',
        'timeout_in_seconds' => 40
    }

    webapp_url = "http://#{config['application_address']}:#{config['application_port']}/#{config['application_name']}"

    config['webapp_url'] = webapp_url

    config
  end

end
# encoding: utf-8

require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "access wikipedia" do

  it "should submit the request with selenium-client" do
    start_selenium_server

    config = load_configuration

    puts "Application: #{config[:webapp_url]}"
    puts "Selenium: #{config[:selenium_host]}:#{config[:selenium_port]}"

    driver = SeleniumDSL::SeleniumClient::DSL.new(
        config[:selenium_host], config[:selenium_port], config[:browser], config[:webapp_url])

    driver.timeout_in_seconds = config['timeout_in_seconds']

    driver.start

    driver.selenium_client do
      open "/"

      is_text_present("The Free Encyclopedia").should be_true

      type "searchInput", "iphone"

      click "go", :wait => true

      is_text_present("iPhone").should be_true
    end

    driver.stop

    stop_selenium_server
  end

  it "should submit the request with selenium webdriver directly" do
    #start_selenium_server

    require 'selenium-webdriver'

    browser = Selenium::WebDriver.for(:firefox)

    browser.get('http://www.wikipedia.org')

    expect(browser.find_element(:id, 'www-wikipedia-org')).not_to be_nil

    browser.find_element(:id, 'searchInput').send_keys("iphone")

    browser.find_element(:name, 'go').click

    wait = ::Selenium::WebDriver::Wait.new(:timeout => 60) # seconds

    wait.until {
      element = browser.find_element(:id, 'content')

      element.attribute("disabled").nil? ? true : element.attribute("disabled")
    }

     expect(browser.element.text).to match /iPhone/

     browser.quit

    #stop_selenium_server
  end

  it "should submit the request with selenium webdriver" do
    start_selenium_server

    config = load_configuration

    puts "Application: #{config[:webapp_url]}"
    puts "Selenium: #{config[:selenium_host]}:#{config[:selenium_port]}"

    driver = SeleniumDSL::SeleniumWebdriver::DSL.new(
        config[:selenium_host], config[:selenium_port], config[:browser])

    driver.timeout_in_seconds = config[:timeout_in_seconds]

    driver.start

    driver.selenium_webdriver do
      get config[:webapp_url]

      expect(find_element(:id, 'www-wikipedia-org')).not_to be_nil

      find_element(:id, 'searchInput').send_keys("iphone")

      find_element(:name, 'go').click

      disabled_condition = condition(lambda { |element| element.attribute("disabled").nil? ? true : element.attribute("disabled") })

      wait_for_condition :id, 'content', disabled_condition

      expect(find_element(:id, 'content').text).to match /iPhone/
    end

    driver.stop

    stop_selenium_server
  end

  it "should submit the request with watir webdriver" do
    config = load_configuration

    driver = SeleniumDSL::WatirWebdriver::DSL.new(config[:browser])

    driver.start

    driver.watir_webdriver do
      goto config[:webapp_url]

      expect(element(:id => 'www-wikipedia-org')).not_to be_nil

      text_field(:id => 'searchInput').set("iphone")

      button(:name => 'go').click

      # todo: 1. how to wait?
      # todo  2. how to use selenium?
      # todo  3. how to use remote selenium?

      #wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
      #wait.until {
      #  driver.find_element(:id, 'content')
      #}

      expect(element(:id, 'content').text).to match /iPhone/

      expect(url).to eq "http://en.wikipedia.org/wiki/Iphone"
    end

    driver.stop
  end

  #it "should submit the request with capybara and webkit" do
  #  config = load_configuration
  #
  #  driver = SeleniumDSL::Capybara::DSL.new(
  #      config[:selenium_host], config[:selenium_port], config[:browser], config[:webapp_url], :webkit)
  #
  #  driver.timeout_in_seconds = config['timeout_in_seconds']
  #
  #  driver.start
  #
  #  driver.capybara do
  #    visit '/'
  #
  #    text.should =~ /The Free Encyclopedia/
  #
  #    expect(find('#www-wikipedia-org')).not_to be_nil
  #
  #    fill_in 'searchInput', :with => 'iphone.com'
  #    click_button '  →  '
  #
  #    ## todo: how to wait?
  #    ##wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
  #    ##wait.until {
  #    ##  driver.find_element(:id, 'content')
  #    ##}
  #
  #    expect(find('#content').text).to match /iPhone/
  #
  #    # "http://en.wikipedia.org/wiki/Special:Search?search=iphone.com&go=Go"
  #    #expect(page.current_url).to eq "http://en.wikipedia.org/wiki/Iphone"
  #
  #    # save_and_open_page
  #  end
  #
  #  driver.stop
  #end
  #
  #it "should submit the request with capybara and selenium" do
  #  start_selenium_server(:port => 4444)
  #
  #  config = load_configuration
  #
  #  driver = SeleniumDSL::Capybara::DSL.new(
  #      config[:selenium_host], config[:selenium_port], config[:browser], config[:webapp_url], :selenium)
  #
  #  driver.timeout_in_seconds = config['timeout_in_seconds']
  #
  #  driver.start
  #
  #  driver.capybara do
  #    visit '/'
  #
  #    text.should =~ /The Free Encyclopedia/
  #
  #    expect(find('#www-wikipedia-org')).not_to be_nil
  #
  #    fill_in 'searchInput', :with => 'iphone.com'
  #    click_button '  →  '
  #
  #    ## todo: how to wait?
  #    # todo: how to execute remote selenium?
  #
  #    ##wait = Selenium::WebDriver::Wait.new(:timeout => 10) # seconds
  #    ##wait.until {
  #    ##  driver.find_element(:id, 'content')
  #    ##}
  #
  #    expect(find('#content').text).to match /iPhone/
  #
  #    # "http://en.wikipedia.org/wiki/Special:Search?search=iphone.com&go=Go"
  #    #expect(page.current_url).to eq "http://en.wikipedia.org/wiki/Iphone"
  #
  #    # save_and_open_page
  #  end
  #
  #  driver.stop
  #
  #  stop_selenium_server
  #end

  private

  def load_configuration
    {
      :webapp_url         => "http://www.wikipedia.org",

      :selenium_host      => "localhost",
      :selenium_port      => "4444",
      :browser            => 'firefox',
      :timeout_in_seconds => 40
    }
  end

end
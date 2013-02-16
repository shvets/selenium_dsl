require 'rubygems' unless Object.const_defined?(:Gem)

# add lib directory
$:.unshift File.dirname(__FILE__) + '/../lib'

require "selenium_dsl"
require 'selenium/server'

SeleniumDSL::SeleniumClient::Script.send :include, RSpec::Matchers
SeleniumDSL::SeleniumWebdriver::Script.send :include, RSpec::Matchers
SeleniumDSL::WatirWebdriver::Script.send :include, RSpec::Matchers
SeleniumDSL::Capybara::Script.send :include, RSpec::Matchers

#RSpec.configuration.include(SeleniumDSL::DSL)

module Selenium::Client::Base
  alias originalInitialize initialize

  def initialize(*args)
    originalInitialize *args

    @highlight_located_element_by_default = true
  end
end

share_examples_for :SeleniumTest do
  before :all do
    start_selenium_server
  end

  after :all do
    stop_selenium_server
  end

end

def start_selenium_server
  require 'selenium'

  version = Selenium::Starter::SELENIUM_SERVER_VERSION
  selenium_server_standalone_jar = "#{ENV['HOME']}/.selenium/assets/selenium-#{version}/selenium-server-standalone-#{version}.jar"

  if File.exist? selenium_server_standalone_jar
    @server = Selenium::Server.new(selenium_server_standalone_jar, :background => true)
    @server.start
  else
    puts "Selenium gem is not installed.Run: selenium install"
  end
end

def stop_selenium_server
  @server.stop if @server
  @server = nil
end

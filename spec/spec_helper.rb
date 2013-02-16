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
    #@server = Selenium::Server.new("#{ENV['HOME']}/.selenium/assets/selenium-2.28.0/selenium-server-standalone-2.28.0.jar", :background => true)
    #@server.start
  end

  after :all do
    #@server.stop
  end

  #before :each do
  #  start_new_session
  #end
  #
  #after :each do
  #  close_session
  #end
end
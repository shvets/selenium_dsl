require 'rubygems' unless Object.const_defined?(:Gem)

# add lib directory
$:.unshift File.dirname(__FILE__) + '/../lib'

require "selenium_dsl"

SeleniumDSL::Script.send :include, RSpec::Matchers

RSpec.configuration.include(SeleniumDSL::DSL)

module Selenium::Client::Base
  alias originalInitialize initialize

  def initialize(*args)
    originalInitialize *args

    @highlight_located_element_by_default = true
  end
end

share_examples_for :SeleniumTest do
  before :each do
    start_new_session
  end

  after :each do
    close_session
  end
end
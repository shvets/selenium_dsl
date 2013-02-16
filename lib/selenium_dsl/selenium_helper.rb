module SeleniumHelper
  def construct_selenium_url host, port
    "http://#{host}:#{port}/wd/hub/"
  end
end
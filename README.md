# SeleniumDSL - Simple way to build Selenium code as DSL

## Installation

Add this line to to your Gemfile:

    gem "selenium_dsl"

And then execute:

    $ bundle

## Usage

```ruby
    require 'selenium_dsl'

    include SeleniumDSL::DSL

    selenium_server_address = 'localhost'
    selenium_server_port = 4444
    selenium_browser_key = '*firefox'
    timeout_in_seconds = 40

    webapp_url = "http://localhost:3000/web_app_name"

    init_selenium(selenium_server_address, selenium_server_port, selenium_browser_key, webapp_url, timeout_in_seconds)

    start_new_session

    selenium do
       open "/#{application_name}"

       click "some_link"

       fill_in("some_field", :with => "some_value")
    end

    close_session

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
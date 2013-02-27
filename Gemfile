source "https://rubygems.org"

gem "selenium-webdriver"
gem "selenium"

group :development do
  gem "gemspec_deps_gen"
  gem "gemcutter"
end

group :test do
  gem "rspec"
  gem "rspec-core"
  gem "rspec-expectations"
  gem "mocha"
  gem "watir-webdriver"
  #gem "capybara", "1.1.4"
  #gem "capybara-webkit", "0.8.0"

  # Note: You need to install qt:
  # Mac: brew install qt
  # Ubuntu: sudo apt-get install libqt4-dev libqtwebkit-dev
  # Debian: sudo apt-get install libqt4-dev
  # Fedora: yum install qt-webkit-devell

  unless File.exist? "/usr/local/Cellar/qt"
    system "brew install qt"
  end
end

group :debug do
  if RUBY_VERSION.include? "1.9"
    unless File.exist? "#{ENV['GEM_HOME']}/gems/linecache19-0.5.13/lib/linecache19.rb"
      `curl -OL http://rubyforge.org/frs/download.php/75414/linecache19-0.5.13.gem`
    `gem i linecache19-0.5.13.gem`
    end

    gem "linecache19", "0.5.13"
    gem "ruby-debug-base19x", "0.11.30.pre10"
    gem "ruby-debug-ide", "0.4.17.beta14"
  end
end

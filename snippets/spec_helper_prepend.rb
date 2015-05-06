require 'simplecov'
Dir['./spec/support/**/*.rb'].sort.each { |f| require f }
SimpleCov.start 'rails'

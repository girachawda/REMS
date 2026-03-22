ENV["RAILS_ENV"] ||= "test"

require "simplecov"
SimpleCov.start do
  enable_coverage :line
end

require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # I had to do this to avoid SQL Database locks in SQLite
    parallelize(workers: 1)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all
  end
end

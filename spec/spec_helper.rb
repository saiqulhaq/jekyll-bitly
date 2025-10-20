require "bundler/setup"
require "dotenv"
Dotenv.load
require "jekyll_bitly_next"
require "vcr"
require "webmock/rspec"
require "jekyll"
require "capybara/rspec"
require "byebug"

# Set up VCR
VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = true

  # Filter sensitive data
  config.filter_sensitive_data("<BITLY_TOKEN>") { ENV["BITLY_TOKEN"] }

  # Match requests ignoring the access token in query parameters
  config.default_cassette_options = {
    match_requests_on: %i[method uri body]
  }
end

# Configure Jekyll for testing
Jekyll.logger.log_level = :error

# Configure Capybara
Capybara.configure do |config|
  config.run_server = false
  config.default_driver = :rack_test
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Environment variables are loaded from .env file via dotenv

  # Clean up after each test
  config.after(:each) do
    # Reset the singleton instance between tests
    Jekyll::BitlyFilterCache.remove_instance_variable(:@singleton__instance__) if Jekyll::BitlyFilterCache.instance_variable_defined?(:@singleton__instance__)
  end
end

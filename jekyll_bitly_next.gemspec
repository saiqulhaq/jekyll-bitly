lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "jekyll_bitly_next/version"

Gem::Specification.new do |spec|
  spec.name                  = "jekyll_bitly_next"
  spec.version               = JekyllBitlyNext::VERSION
  spec.authors               = ["Torgny Bjers", "Saiqul Haq"]
  spec.email                 = ["torgny.bjers@gmail.com", "saiqulhaq@gmail.com"]

  spec.summary               = "Jekyll Bit.ly filter"
  spec.description           = "Jekyll filter that uses Bit.ly to shorten URLs."
  spec.homepage              = "https://github.com/saiqulhaq/jekyll_bitly_next"
  spec.license               = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "bitly", "~> 3.0.0"
  spec.add_runtime_dependency "dry-core", "~> 1.0.0"

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "capybara"
  spec.add_development_dependency "csv"
  spec.add_development_dependency "dotenv"
  spec.add_development_dependency "jekyll"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "selenium-webdriver"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"
end

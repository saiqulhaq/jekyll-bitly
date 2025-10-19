require "spec_helper"

RSpec.describe "Jekyll Integration", :vcr do
  let(:source_dir) { File.expand_path("../fixtures", __dir__) }
  let(:destination_dir) { File.expand_path("../fixtures/_site", __dir__) }

  let(:site) do
    Jekyll::Site.new(Jekyll.configuration({
                                            "source" => source_dir,
                                            "destination" => destination_dir,
                                            "url" => "http://localhost:4000",
                                            "baseurl" => ""
                                          }))
  end

  before(:all) do
    # Ensure we have the token from .env
    puts "Warning: BITLY_TOKEN not found in environment" unless ENV["BITLY_TOKEN"]
  end

  describe "Jekyll Build Integration", vcr: { cassette_name: "jekyll_build_integration" } do
    before do
      # Clean the destination directory
      FileUtils.rm_rf(destination_dir) if Dir.exist?(destination_dir)
    end

    it "builds the Jekyll site successfully with bitly filter" do
      # Process the site
      site.process

      # Check that the site was built
      expect(Dir.exist?(destination_dir)).to be true
      expect(File.exist?(File.join(destination_dir, "index.html"))).to be true

      # Read the generated HTML
      html_content = File.read(File.join(destination_dir, "index.html"))

      # Verify that bitly URLs were generated
      expect(html_content).to include("https://bit.ly/")

      # Verify specific links were shortened
      expect(html_content).to match(%r{href="https://bit\.ly/[a-zA-Z0-9]+})

      # Verify data attributes contain shortened URLs
      expect(html_content).to match(%r{data-short-url="https://bit\.ly/[a-zA-Z0-9]+})
    end

    it "generates different short URLs for different long URLs" do
      site.process

      html_content = File.read(File.join(destination_dir, "index.html"))

      # Extract all bit.ly URLs
      bitly_urls = html_content.scan(%r{https://bit\.ly/[a-zA-Z0-9]+})

      # Should have multiple shortened URLs
      expect(bitly_urls.length).to be >= 3

      # Check for at least 3 unique URLs (since we have github, example.com, and github search)
      unique_urls = bitly_urls.uniq
      expect(unique_urls.length).to be >= 3

      # Verify all URLs are valid bitly format
      unique_urls.each do |url|
        expect(url).to match(%r{^https://bit\.ly/[a-zA-Z0-9]+$})
      end
    end
  end

  describe "Static File Testing" do
    before do
      site.process
    end

    it "creates valid HTML structure" do
      html_file = File.join(destination_dir, "index.html")
      html_content = File.read(html_file)

      # Basic HTML structure checks
      expect(html_content).to include("<!DOCTYPE html>")
      expect(html_content).to include("<html")
      expect(html_content).to include("</html>")
      expect(html_content).to include("Test Site")
    end

    it "contains the expected test content" do
      html_file = File.join(destination_dir, "index.html")
      html_content = File.read(html_file)

      # Check for our test content
      expect(html_content).to include("Test Page")
      expect(html_content).to include("Test Links")
      expect(html_content).to include("GitHub Repository")
      expect(html_content).to include("Example URL")
      expect(html_content).to include("URL with Parameters")
    end
  end

  describe "HTML Content Validation" do
    before do
      site.process
    end

    it "generates valid shortened links in HTML" do
      html_file = File.join(destination_dir, "index.html")
      html_content = File.read(html_file)

      # Parse with Nokogiri for better HTML parsing
      require "nokogiri"
      doc = Nokogiri::HTML(html_content)

      # Check basic structure
      expect(doc.at_css("title").text).to eq("Test Page")
      expect(doc.at_css("h1").text).to eq("Test Site")

      # Check for shortened links
      bitly_links = doc.css("a[href*='bit.ly']")
      expect(bitly_links.count).to be > 0

      # Verify each link is properly formed
      bitly_links.each do |link|
        href = link["href"]
        expect(href).to match(%r{^https://bit\.ly/[a-zA-Z0-9]+$})
      end

      # Check content
      expect(html_content).to include("GitHub Repository")
      expect(html_content).to include("Example URL")
      expect(html_content).to include("URL with Parameters")
    end

    it "has correct data attributes with shortened URLs" do
      html_file = File.join(destination_dir, "index.html")
      html_content = File.read(html_file)

      require "nokogiri"
      doc = Nokogiri::HTML(html_content)

      # Find elements with data attributes
      test_divs = doc.css("div[data-short-url]")
      expect(test_divs.count).to be > 0

      test_divs.each do |div|
        short_url = div["data-short-url"]
        original_url = div["data-original-url"]

        expect(short_url).to match(%r{^https://bit\.ly/[a-zA-Z0-9]+$})
        expect(original_url).to start_with("https://")

        # NOTE: Some short URLs like example.com might not be shorter when bitly-fied
        # The important thing is that they are valid bitly URLs
        expect(short_url).to include("bit.ly")
      end
    end
  end
end

require "spec_helper"

RSpec.describe "Jekyll Build Debug" do
  let(:source_dir) { File.expand_path("../fixtures", __FILE__) }
  let(:destination_dir) { File.expand_path("../fixtures/_site", __FILE__) }

  it "debugs Jekyll configuration and build process" do
    puts "Source directory: #{source_dir}"
    puts "Destination directory: #{destination_dir}"
    puts "Source exists: #{Dir.exist?(source_dir)}"
    puts "Files in source: #{Dir.entries(source_dir)}"
    
    config = Jekyll.configuration({
      "source" => source_dir,
      "destination" => destination_dir,
      "url" => "http://localhost:4000",
      "baseurl" => ""
    })
    
    puts "Jekyll config: #{config.inspect}"
    
    site = Jekyll::Site.new(config)
    
    begin
      puts "Starting Jekyll build..."
      site.process
      puts "Jekyll build completed"
      
      puts "Destination exists: #{Dir.exist?(destination_dir)}"
      if Dir.exist?(destination_dir)
        puts "Files in destination: #{Dir.entries(destination_dir)}"
      end
      
    rescue => e
      puts "Jekyll build failed: #{e.class}: #{e.message}"
      puts e.backtrace.first(10)
    end
  end
end
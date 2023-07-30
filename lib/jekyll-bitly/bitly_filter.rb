require "bitly"
require "singleton"
require "dry-core"
require 'dry/core/cache'

module Jekyll
  class BitlyFilterCache
    include Singleton
    extend Dry::Core::Cache

    def initialize
      config = Jekyll.configuration({})
      if config && config["bitly"] && config["bitly"]["token"]
        @bitly_client = Bitly::API::Client.new(token: config["bitly"]["token"])
      end
    end

    def shorten(input)
      input.strip!
      fetch_or_store(self.class.to_s, input) do 
        bitlink = bitly.shorten(input, history: 1)
        short_url = bitlink.link
        short_url
      end
    end
  end

  module BitlyFilter
    def bitly(input)
      BitlyFilterCache.instance.shorten(input)
    end
  end
end

Liquid::Template.register_filter(Jekyll::BitlyFilter)

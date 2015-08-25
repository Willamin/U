require 'core/alchemy/article'
require 'typhoeus'

module U::Core::Alchemy
  class Client
    class ExtractionError < StandardError; end

    def initialize
      @root = 'https://access.alchemyapi.com/calls'
      @api_key = ENV['ALCHEMY_TOKEN']

      if @api_key.nil?
        raise FeatureDisabled, "Alchemy API disabled due to missing ENV Variable ALCHEMY_TOKEN."
      end
    end
    
    def extract_article page
      url = "#{@root}/url/URLGetText?apikey=#{@api_key}&outputMode=json&url=#{page}"

      response = Typhoeus.get url
      json = JSON.parse response.body

      if json['status']
        Article.new json['url'], json['language'], json['text']
      else
        raise ExtractionError, "Could not extract from #{page}"
      end
    end
  end
end

require 'core/dandelion/article'
require 'typhoeus'

module U::Core::Dandelion
  class Client
    class ExtractionError < StandardError; end

    def initialize
      @root = 'https://api.dandelion.eu'
      @api_key = ENV['DANDELION_TOKEN']

      if @api_key.nil?
        raise U::Core::FeatureDisabled, "Dandelion API disabled due to missing ENV Variable DANDELION_TOKEN."
      end
    end
    
    def extract_article url
      endpoint = "#{@root}/datatxt/nex/v1?token=#{@api_key}"
      response = Typhoeus.post endpoint, body: { url: url }
      json = JSON.parse response.body
      Article.new json['url'], json['lang'], json['text']
    end
  end
end

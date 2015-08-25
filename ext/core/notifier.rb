require 'net/https'

class U::Core::Notifier
  def initialize
    @app_token = ENV['PUSHOVER_APP_TOKEN']
    @user_key = ENV['PUSHOVER_USER_KEY']

    if @app_token.nil? || @user_key.nil?
      raise U::Core::FeatureDisabled, "Pushover notifications disabled due to missing ENV Variable(s) PUSHOVER_APP_TOKEN and/or PUSHOVER_USER_KEY"
    end
  end

  def notify(message, opts = { title: 'U', token: @app_token, user: @user_key })
    url = URI.parse 'https://api.pushover.net/1/messages.json'
    request = Net::HTTP::Post.new url
    request.set_form_data({ message: message }.merge(opts))
    response = Net::HTTP.new(url.host, url.port)
    response.use_ssl = true
    response.verify_mode = OpenSSL::SSL::VERIFY_PEER
    response.start { |http| http.request(request) }
  end
end

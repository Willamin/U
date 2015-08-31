class Example < U::Package
  include U::Core
  VERSION = U::VERSION # use "x.x.x" for your own packages

  script 'version' do
    uprint U::VERSION
  end

  script 'about' do
    uprint 'U are a conglomerate of custom utilities for Caleb Albritton\'s personal use.'
  end

  script 'root' do
    uprint U::ROOT_DIR
  end

  script 'send test notification' do
    notify "Pushover has been setup properly"
  end

  script 'send test email' do
    email to: me, subject: 'Test Email from U', body: "This is the body of the email in plain text."
  end

  script 'extract article' do |url|
    begin
      article = Alchemy::Client.new.extract_article url
      email to: me, subject: "Extracted Article", body: "#{article.text}\n\n\nSource: #{url}"
    rescue Alchemy::Client::ExtractionError => e
      uprint e.to_s, :error
    end
  end
end

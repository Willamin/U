require 'mechanize'
require 'digest'

class Wallhaven < U::Package

  VERSION = '1.0.0'

  script 'get a wallpaper' do |resolution, category|
    random_url = "http://alpha.wallhaven.cc/search?q=#{category}&categories=100&purity=100&resolutions=#{resolution}&sorting=random&order=desc"
    random_regex = /http:\/\/alpha.wallhaven.cc\/wallpaper\/\d+/

    crawler = Mechanize.new

    page = crawler.get random_url 
    images = page.links.select do |a|
      unless a.href.nil?
        a.href.match(random_regex)
      end
    end

    page = crawler.get images.first.href
    image_url = 'http:' + page.at('#wallpaper')['src']

    image = Net::HTTP.get URI.parse(image_url)

    image_path = File.join(Dir.home, 'Pictures/Wallpapers', "#{SecureRandom.uuid}.jpg")
    File.open(image_path, 'w') { |file| file.write(image) }

    `osascript -e 'tell application "System Events" to set picture of every desktop to "#{image_path}"'`

    uprint "Fetched new wallpaper from Wallbase and set as desktop background. Saved to #{image_path}"
  end
end

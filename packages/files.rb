require 'webrick'

class FileOperations < U::Package

  script 'delete duplicates' do
    files = Dir.entries(Dir.pwd).reject { |f| f == '.' || f == '..' || f == '.DS_Store' }

    hashes = {}

    files.each do |file|
      hash = Digest::SHA2.hexdigest File.read(file)
      
      if hashes[hash].nil?
        hashes[hash] = [file]
      else
        hashes[hash] << file
      end
    end

    to_delete = []

    hashes.each do |key, value|

      if value.length > 1
        to_delete << value[1..-1]
      end
    end

    to_delete.flatten!
    to_delete.each { |file| FileUtils.rm file }

    uprint "Deleted #{to_delete.length} duplicates."
  end

  script 'serve folder' do |port|
    server = WEBrick::HTTPServer.new Port: port, DocumentRoot: Dir.pwd

    Signal.trap('INT') do
      server.shutdown
    end

    server.start
  end
end

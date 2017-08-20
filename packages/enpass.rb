require 'io/console'
require 'sqlite3'

class Enpass < U::Package
  script 'pass' do
    db_path = '~/Documents/Enpass/walletx.db'
    print 'Password: '
    password = STDIN.noecho(&:gets).chomp
    puts
    binding.pry
    SQLite3::Database.new db_path do |db|
      db.enable_load_extension true
      db.execute "PRAGMA key='#{password}'"
      db.execute 'PRAGMA kdf_iter = 24000'
    end
  end
end
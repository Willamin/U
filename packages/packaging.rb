class Packaging < U::Package

  VERSION = U::VERSION

  script 'install to path' do
    if File.exist? '/usr/local/bin/u'
      uprint "Already symlinked to /usr/local/bin"
    else
      `ln -s #{U::ROOT_DIR}/u /usr/local/bin/u`
    end
  end

  script 'installed packages' do
    packages = U::Package.packages.map do |package|
      [package::VERSION, package.to_s]
    end

    packages.each do |package|
      uprint package.join "\t"
    end
  end

  script 'install' do |package|
    uprint "Installing #{package}..."

    info = package.split('/')
    user = info[0]
    name = info[1]

    unless File.directory?(U::PACKAGE_DIR)
      Dir.mkdir(U::PACKAGE_DIR)
    end

    `git clone https://github.com/#{package}.git #{U::PACKAGE_DIR}/#{name}`

    uprint "#{name} installed!"
  end
end
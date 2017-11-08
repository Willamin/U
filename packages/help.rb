class Help < U::Package
  VERSION = U::VERSION # use "x.x.x" for your own packages

  script 'help' do
    scripts = U::Package.scripts.map { |scriptname, _| scriptname }
    scripts.insert(0, "available scripts:")
    uprint scripts.join("\n\t  ")
  end
end

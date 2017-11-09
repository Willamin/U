class Help < U::Package
  VERSION = U::VERSION # use "x.x.x" for your own packages

  script 'help' do
    scripts = U::Package.scripts.map do |name, block|
      params = get_script_params(block)

      if !params.empty?
        "#{name}: #{params.join(' ')}"
      else
        name
      end
    end

    scripts.insert(0, "available scripts:")
    uprint scripts.join("\n\t ")
  end
end

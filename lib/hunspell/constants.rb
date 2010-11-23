module Hunspell
  
  BootstrapError = Class.new(StandardError)
  
  if !self.const_defined?('LIBRARY_PATH')
    raise BootstrapError.new('You must define Hunspell::LIBRARY_PATH' + 
      'as the path to your library file prior to require this library')
  end
  
  DEFAULT_CONFIG_PATH = File.join(File.dirname(__FILE__),'..','..','config','hunspell.yml')
  CONFIGURATION = if File.exist?(DEFAULT_CONFIG_PATH)
    YAML.load(File.read(DEFAULT_CONFIG_PATH)) 
  end
  
end
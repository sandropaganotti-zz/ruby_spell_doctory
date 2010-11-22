module Hunspell
  
  BootstrapError = Class.new(StandardError)
  
  if !self.const_defined?('LibraryPath')
    raise BootstrapError.new('You must define Hunspell::LibraryPath 
      as the path to your library file prior to require this library')
  end
  
  DefaultConfigPath = File.join(File.dirname(__FILE__),'..','..','config','hunspell.yml')
  Configuration = if File.exist?(DefaultConfigPath)
    YAML.load(File.read(DefaultConfigPath)) 
  end
  
end
require 'ffi'
require 'yaml'

class Hunspell
  
  # load the default configuration file (silently fail if none available)
  Configuration = YAML::load(File.read(File.join(File.dirname(__FILE__),'..','config','hunspell.yml'))) rescue nil
  
  # initialize the class and the anonymus module acting as a wrapper to hunspell
  def initialize(config_obj = nil)
    libdir, @dicts = bootstrap(config_obj || Configuration)        
    @bridge = Module.new do 
      extend FFI::Library
      ffi_lib(libdir)
      attach_function :create,  :Hunspell_create, [:string,  :string], :pointer
      attach_function :spell,   :Hunspell_spell,  [:pointer, :string], :int
      attach_function :suggest, :Hunspell_suggest,[:pointer, :pointer, :string], :int;
    end
    respawn_handler('default')
  end

  def respawn_handler(dictionary)
    # create the hunspell library object
    @hunspell = FFI::MemoryPointer.new :pointer
    @hunspell = @bridge.create(@dicts[dictionary]['aff'],@dicts[dictionary]['dic'])
  end
  
  # returns 0 if words is not correct, not 0 otherwise
  def spell(word)
    @bridge.spell(@hunspell,word)
  end
  
  # returns an array with suggested words of a given word ([] if no suggestions)
  def suggest(word)
    suggestions = FFI::MemoryPointer.new :pointer, 1
    suggestions_number = @bridge.suggest(@hunspell,suggestions, word)
    suggestion_pointer = suggestions.read_pointer
    suggestion_pointer.null? ? [] : suggestion_pointer.get_array_of_string(0,suggestions_number).compact
  end
  
  private
  
  # get lib directory and default dictionary path
  def bootstrap(config_obj)
    raise BootstrapError.new("No configuration info supplied to Hunspell constructor and no default configuration file available") if config_obj.nil? 
    return config_obj['library'], config_obj['dictionaries'].merge({'default' => config_obj['dictionaries'][config_obj['dictionaries']['default']]})
  end
  
end
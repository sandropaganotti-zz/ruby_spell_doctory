module Hunspell
  class Hunspell
  
    # initialize the class and the anonymus module acting as a wrapper to 
    # hunspell
    def initialize(config_obj = nil)
      @dicts = bootstrap(config_obj || CONFIGURATION)        
      respawn_handler('default')
    end 
  
    def respawn_handler(dictionary)
      # create the hunspell library object
      @hunspell = FFI::MemoryPointer.new :pointer
      @hunspell = Wrapper.create(
        @dicts[dictionary]['aff'],@dicts[dictionary]['dic']
      )
    end
  
    # returns true if words is not correct, false otherwise
    def spelled_correctly?(word)
      Wrapper.spell(@hunspell,word) != 0
    end
  
    # returns an array with suggested words of a given word ([] if no 
    # suggestions)
    def suggest(word)
      suggestions = FFI::MemoryPointer.new :pointer, 1
      suggestions_number = Wrapper.suggest(@hunspell,suggestions, word)
      suggestion_pointer = suggestions.read_pointer
      if (suggestion_pointer.null?) 
        [] 
      else 
        suggestion_pointer.get_array_of_string(0,suggestions_number).compact 
      end
    end
  
    private
  
    # get lib directory and default dictionary path
    def bootstrap(config_obj)
      if config_obj.nil? 
        raise BootstrapError.new("No configuration info supplied to Hunspell" + 
            "constructor and no default configuration file available") 
      end
      return config_obj['dictionaries'].merge({
          'default' => config_obj['dictionaries'][
                          config_obj['dictionaries']['default']]
      })
    end
  
  end
end
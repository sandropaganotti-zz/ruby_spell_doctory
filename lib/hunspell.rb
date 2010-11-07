require 'ffi'

class Hunspell
  
  # initialize the class and the anonymus module acting as a wrapper to hunspell
  def initialize(libdir, affix, dict)
    @bridge = Module.new do 
      extend FFI::Library
      ffi_lib(libdir)
      attach_function :create, :Hunspell_create, [:string, :string], :pointer
      attach_function :spell,  :Hunspell_spell,  [:pointer,:string], :int
    end
    # create the hunspell library object
    @hunspell = FFI::MemoryPointer.new :pointer
    @hunspell = @bridge.create(affix,dict)
  end
  
  # returns 0 if words is not correct, not 0 otherwise
  def spell(word)
    @bridge.spell(@hunspell,word)
  end
  
end
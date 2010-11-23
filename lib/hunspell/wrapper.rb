module Hunspell
  module Wrapper
    extend FFI::Library
    ffi_lib(LIBRARY_PATH)
    attach_function :create,  :Hunspell_create, [:string,  :string], :pointer
    attach_function :spell,   :Hunspell_spell,  [:pointer, :string], :int
    attach_function :suggest, :Hunspell_suggest,[:pointer, :pointer, :string], :int;
  end
end
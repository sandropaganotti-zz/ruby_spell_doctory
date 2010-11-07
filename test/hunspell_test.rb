require 'rspec'
require File.dirname(__FILE__) + "/../lib/hunspell"


describe Hunspell do
  before :all do 
    @hunspell = Hunspell.new(
      '/Users/sandropaganotti/RMU/hunspell/src/src/hunspell/.libs/libhunspell-1.2.dylib',
      '/Users/sandropaganotti/RMU/hunspell/hunspell_en_dict/en_US.aff',
      '/Users/sandropaganotti/RMU/hunspell/hunspell_en_dict/en_US.dic'
      )
  end
  
  it 'loads the dynamic hunspell library' do
    @hunspell.instance_variable_get('@bridge').should be_a_kind_of(Module)
  end
  
  it 'lets you check for a given phrase' do
    @hunspell.spell("asdasdsadssad").should == 0
    @hunspell.spell("hello").should_not == 0
  end
  
  it 'shows you suggestion of a bad-spelled word' do
    suggestions = @hunspell.suggest('helllo')
    suggestions.size.should > 0 
    suggestions.include?('hello').should == true
  end
  
  it 'show an empty suggestion array if does not find any suitable suggestion' do
    suggestions = @hunspell.suggest('sdasdsdasdashdjakshdkashdkjasdhk')
    suggestions.size.should == 0     
  end
  
end
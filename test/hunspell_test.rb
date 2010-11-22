require 'rspec'

module Hunspell
  # redefine this constant to your library before launching tests
  LibraryPath = "/Users/sandropaganotti/RMU/hunspell/src/src/hunspell/.libs/libhunspell-1.2.dylib"
end

require File.dirname(__FILE__) + "/../lib/hunspell"


describe Hunspell::Hunspell do
  before :each do 
    Hunspell::Configuration['dictionaries'].merge({
      'en' => {
        'aff' => File.join(File.dirname(__FILE__),'fixtures','en_US.aff'),
        'dic' => File.join(File.dirname(__FILE__),'fixtures','en_US.dif')
      },
      'it' => {
        'aff' => File.join(File.dirname(__FILE__),'fixtures','it_IT.aff'),
        'dic' => File.join(File.dirname(__FILE__),'fixtures','it_IT.dif')
      }
    })
    
    @hunspell = Hunspell::Hunspell.new()
  end
  
  
  it 'lets you check for a given phrase' do
    @hunspell.spelled_correctly?("asdasdsadssad").should be_false
    @hunspell.spelled_correctly?("hello").should be_true
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
  
  it 'lets you change language (if present in config)' do
    @hunspell.respawn_handler('it')
    @hunspell.spelled_correctly?("ciao").should be_true
  end
  
end

describe Hunspell do
  
  it 'loads correctly the default config obj' do
    Hunspell::Configuration.should_not be_nil
    Hunspell::Configuration.should include 'dictionaries'
  end
  
  it 'lets you specify an alternative config obj' do 
    @another_config = Hunspell::Hunspell.new(
      { 'dictionaries'  => {
          'default' => 'eo',
          'eo' => {
            'aff' => File.join(File.dirname(__FILE__),'fixtures','eo_l3.aff'),
            'dic' => File.join(File.dirname(__FILE__),'fixtures','eo_l3.dif')
          }
        }
      })
  end
  
end
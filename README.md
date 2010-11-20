Ruby Spell Doctor
============

Install
-------

* Download and compile hunspell (http://downloads.sourceforge.net/hunspell/hunspell-1.2.12.tar.gz)
* Download some dictionaries (en_us: http://sourceforge.net/projects/hunspell/files/Spelling%20dictionaries/en_US/en_US.zip/download)
* Download this library in a folder of your choice
* execute 'bundle install' from the root of this library

Configuration
-------------

* *for usage:* You need to change config/hunspell.yml in accordion to your library and dictionaries path.
* *for test:*  You need also to change config/hunspell.yml but only the 'library' param.

Test
----

    bundle exec rspec test/*

Usage
-----

    require 'lib/hunspell'
    hunspell = Hunspell.new 
    hunspell.spell 'asdasdas' 
    #=> 0 
    hunspell.spell 'hello'
    #=> 1
    hunspell.respawn_handler 'it'
    hunspell.spell 'hello'
    #=> 0
    hunspell.spell 'ciao'
    #=> 1

Credits
-------
All the dictionaries, used for testing purpose and placed under the /test/fixtures folder, are
not created by me and belongs from the official OpenOffice dictionaries page: 
http://wiki.services.openoffice.org/wiki/Dictionaries


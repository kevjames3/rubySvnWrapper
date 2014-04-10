rubySvnWrapper
========

A lightweight wrapper written in Ruby for the Linux command line SVN interface. It allows basic interaction with an SVN repository, including adding, renaming, deleting, committing, diffing and checking the status of files.

This is for people who are looking for a quick solution for SVN integration in their projects and who don't want to deal with Ruby bindings.  However, it is advisable if you are looking for a more efficient solution to look into Ruby Bindings.

Licensed under the MIT license (See LICENSE.txt for details)

Authors: Kevin McIntosh, forked from Andrew Berkeley's project

Copyright: Copyright (c) Kevin McIntosh

Homepage: https://github.com/kevjames3/rubySvnWrapper


Installation
------------

Just include the code somewhere appropriate


Requirements
------------

 * UNIX system or Windows System
 * SVN installation (The wrapper executes from the command line)
 * Ruby!

Usage
-----

Simply calling

```ruby
svn = SvnWrapper.new(:username => username, :password => password)
```

creates the instance of the repository.  A note about the parameters...

1. SvnWrapper has three instance variables that can be set at initialization or later (attr_accessor)
  * :username
  * :password
  * :quiet

2. Also has a read-only variable that gives the last exit code of the svn executable - it is of type Process.  It is nil until svn is called
  * :processReturn

Examples
--------

```ruby
   #Since SVN typically caches the user name and password,
   #these arguments are optional
   username = "a_username"
   password = "a_password"

   svn = SvnWrapper.new(:username => username, :password => password)
```

```ruby
   #checkout example
   puts "Checking out '#{options[:repo]}'"
   svn.quiet = false
   svn.checkout("RepoLocation", "FolderLocation")
   svn.quiet = true
```

```ruby
   #update example
   svn.quiet = false
   svn.update("FolderLocation")
   svn.quiet = true

   if(svn.processReturn.exitstatus != 0)
      puts "Folder had a bad update, trying to clean up..."
      svn.cleanup("FolderLocation")

      puts "Updating again..."
      svn.quiet = false
      svn.update("FolderLocation")
      svn.quiet = true
   end
```

   
	






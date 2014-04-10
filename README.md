rubySvnWrapper
========

A lightweight wrapper written in Ruby for the Linux command line SVN interface. It allows basic interaction with an SVN repository, including adding, renaming, deleting, committing, diffing and checking the status of files.

This is for people who are looking for a quick solution for SVN integration in their projects and who don't want to deal with Ruby bindings.  However, it is advisable if you are looking for a more efficient solution to look into Ruby Bindings

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
 * SVN installation
 * Ruby!

Usage
-----

SVN authentication credentials must be initialized as follows:

	SVN.username = "a_username"
	SVN.password = "a_password"

File management can then be performed:

	File.open("new_file.txt", 'w') { |file| file.write "This is a new file" }

	SVN.status                               => [["?", "new_file.txt"]]

	SVN.add "new_file.txt"                   => "A         new_file.txt\n"

	SVN.commit "adding new file"             => "12345 // new revision number




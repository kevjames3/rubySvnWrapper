require 'net/http'
require 'uri'

class SvnWrapper

  attr_accessor(
    :username, #DEFAULT: "".  If blank, will use the username in the SVN cache
    :password, #DEFAULT: "".  If blank, will use the password in the SVN cache
    :quiet #DEFAULT: true. Set to false to print STDOUT and STDERR of svn.exe to output
    )
  attr_reader(:processReturn) #this is the last return code

  def initialize(args = {})
    @username = args[:username] unless args[:username].nil?
    @password = args[:password] unless args[:password].nil?
    @quiet    = args[:quiet].nil? ? true : args[:quiet].nil?
  end
  
  # Returns a string to be passed into commands containing authentication options
  def authentication_details
    details = ""
    if defined? @@username
      details += "--username #{@username}"
    end
     
    if defined? @@password
      details += "--password #{@password}"
    end
     
    return details 
  end

  # Returns an array representing the current status of any new or modified files
  def status(folderLocation)
    execute("status #{folderLocation}").split(/\n/).map do |file|
      file =~ /(\?|\!|\~|\*|\+|A|C|D|I|M|S|X)\s*([\w\W]*)/
      [$1, $2]
    end
  end
  
  # Adds the given path to the working copy
  def add(path)
    execute("add #{path}")
  end
  
  # Adds all new or modified files to the working copy
  def add_all
    status.each { |file| add = add(file[1]) if file[0] == '?' }
  end
  
  # Add all new or modified files to the working copy and commits changes
  # An optional commit message can be passed if required
  def add_and_commit_all(message=nil)
    add_all
    commit message
  end
  
  #Checkout a folder from repoAddress to folderLocation
  def checkout(repoAddress, folderLocation)
    execute("co #{repoAddress} #{folderLocation}")
  end

  #Cleanup a folder
  def cleanup(folder)
    execute("cleanup #{folder}")
  end

  # Commits all changes, and returns the new revision number
  # An optional commit message can be passed if required
  def commit(message=nil)
    if message.nil?
      action = execute("commit")
    else
      action = execute("commit -m '#{message}'")
    end
    if action.split(/\n/).last =~ /Committed revision (\d+)\./
      return $1
    else
      return nil
    end
  end

  # Delete a file based on a given path
  def delete(file)
    execute("delete #{file}")
  end
  
  # Returns a diff of two commits based on their respective revision numbers
  # (first and second arguments) and a repository path (third argument)
  def diff(revision_1,revision_2,file=nil)
    if file.nil?
      execute("diff -r #{revision_1}:#{revision_2}")
    else
      execute("diff -r #{revision_1}:#{revision_2} #{file}")
    end
  end

  # Retrieve a file based on it's path and commit revision number
  def get(file,revision)
    execute("cat -r #{revision} #{file}")
  end

  # Returns true if the folder is an instance of a checked out repository
  def isCheckedOutRepo?(location)
    execute("info #{location}")
    return (@processReturn.exitstatus == 0)
  end

  # Rename a file based on the given current and new filenames
  def rename(old_filename, new_filename)
    execute("rename #{old_filename} #{new_filename}")
  end

  #Update a file or folder.  If no revision is given, it will update to HEAD
  def update(file, revision = "HEAD")
    execute("update -r#{revision} \"#{file}\"")
  end

  private

  def execute(command)
    stdoutAndStderr = ""
    command = "svn #{command} #{authentication_details} 2>&1"
    IO.popen(command) do |stream|
      stream.each do |line|
        stdoutAndStderr += line
        puts line unless @quiet
      end
    end

    @processReturn = $?

    return stdoutAndStderr
  end

end
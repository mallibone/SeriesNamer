#!/Users/markallibone/.rvm/rubies/ruby-1.9.3-p0/bin/ruby

require 'thor'
require_relative '../lib/renamer'

class Solitair < Thor

  desc "name path/series(/season XX)", "name episodes of given series"
  def name( path )
    unless Dir.exists?(path)
      puts "Error: Path #{path} doesn't exist!"
      exit
    end

    # get list of episodes
    begin
      Rename( path ).new.now
      puts "","Thanks for all the fish!", ""
    rescue ArgumentError => error
      puts "", error.to_s
      puts "","Now I'm really depressed, something went wrong..",""
    end

  end

  desc "hello_world", "prints out hello world to the console"
  def hello_world( )

    puts "Hello World"

  end
end

Solitair.start

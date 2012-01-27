require 'minitest/spec'
require 'minitest/autorun'

require_relative 'spec_helper'

describe "The manager object" do
  describe "executes the given objects in the right order" do

    def setup
      @path = "Burn Notice/Season 1"
    end

    it "takes a path" do
      path = Dir.pwd
      SeriesNamer::Renamer.new( path ).path.must_equal path
    end

    it "makes sure the path is valid" do
      path = "/inexistend/path"

      proc {SeriesNamer::Renamer.new( path )}.must_raise(ArgumentError)
    end

    it "gets all the entries" do
      expected_entries = ["episode 1", "episode 2", "episode 3"]
      given_entries = Array.new(expected_entries) << "." << ".." << "dir_something"

      dir_mock = MiniTest::Mock.new
      dir_mock.expect(:exists?, true, [@path] )
      dir_mock.expect(:entries, Array.new(given_entries), [@path])

      SeriesNamer::Renamer.new( @path, dir_mock, DummyFile.new ).entries.must_equal expected_entries
    end

    it "it gets all the episode names per season" do
      skip
    end

    it "renames all the episodes per season"
  end
end

module SeriesNamer

  require_relative '../lib/find_episodes'

  class Renamer

    attr_reader :path

    @dir #defaults to ruby dir used for tests
    @file #defaults to ruby file used for tests

    def initialize( path, dir = Dir, file = File )
      @dir = dir

      raise ArgumentError, "Path #{path} does not exist" unless @dir.exists?( path )

      @path = path
      @file = file
    end

    def entries
      return FindEpisodes.new(@path, @dir, @file).results
    end
  end

end


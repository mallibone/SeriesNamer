require_relative 'spec_helper'

require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/series_info'

describe "The manager object" do
  describe "executes the given objects in the right order" do

    def setup
      @path = "Burn Notice/Season 1"
      #@path = SeriesNamer::SeriesInfo.new("Burn Notice/Season 1","Burn Notice","Season 1")
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
      dir_mock.expect(:entries, given_entries, [@path])

      VCR.use_cassette('burn_notice_season1_all_episodes') do
        renamer = SeriesNamer::Renamer.new( @path, dir_mock, DummyFile.new )
        renamer.execute
        renamer.series_info.episodes("Season 1").must_equal expected_entries
      end

      dir_mock.verify.must_equal true
    end

    it "it gets all the episode names per season" do
      expected_entries = ["S01E01 Burn Notice", "S01E02 Identity", "S01E03 Fight or Flight"]
      given_entries = ["episode 1", "episode 2", "episode 3", ".", "..", "dir_something"]

      dir_mock = MiniTest::Mock.new
      dir_mock.expect(:exists?, true, [@path] )
      dir_mock.expect(:entries, given_entries, [@path])

      VCR.use_cassette('burn_notice_season1_all_episodes') do
        renamer = SeriesNamer::Renamer.new( @path, dir_mock, DummyFile.new )
        renamer.execute
        renamer.series_info.new_episodes(renamer.series_info.seasons.first).must_equal expected_entries
      end

      dir_mock.verify.must_equal true
    end

    it "renames all the episodes per season" do
      skip
      expected_entries = ["S01E01 Burn Notice", "S01E02 Identity", "S01E03 Fight or Flight"]
      given_entries = ["episode 1", "episode 2", "episode 3", ".", "..", "dir_something"]

      dir_mock = MiniTest::Mock.new
      dir_mock.expect(:exists?, true, [@path] )
      dir_mock.expect(:entries, given_entries, [@path])

      VCR.use_cassette('burn_notice_season1_all_episodes') do
        renamer = SeriesNamer::Renamer.new( @path, dir_mock, DummyFile.new )
        renamer.execute
        renamer.series_info.
          new_episodes(renamer.series_info.seasons.first).
          must_equal expected_entries
      end

      dir_mock.verify.must_equal true
    end
  end
end

module SeriesNamer

  require_relative '../lib/find_episodes'
  require_relative '../lib/get_episode_names'
  require_relative '../lib/parse_path'

  class Renamer

    attr_reader :path, :series_info

    @dir #defaults to ruby dir used for tests
    @file #defaults to ruby file used for tests

    def initialize( path, dir = Dir, file = File )
      @dir = dir

      raise ArgumentError, "Path #{path} does not exist" unless @dir.exists?( path )

      @path = path
      @file = file
    end

    def execute
      @series_info = ParsePath.new(@path, @dir, @file).series_info

      @series_info.add_episodes(@series_info.seasons.first, get_dir_entries)

      @series_info.add_new_episodes(
        @series_info.seasons.first, get_episode_names
      )

    end

    private

    def get_dir_entries
      return FindEpisodes.new(@series_info, @dir, @file).results
    end

    def get_episode_names
      return GetEpisodeNames.new(@series_info).episode_names(
        @series_info.seasons.first[@series_info.seasons.first.size-1].to_i, 
        @series_info.episodes(@series_info.seasons.first).size )
    end
  end

end


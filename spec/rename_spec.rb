require_relative 'spec_helper'

require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/series_info'
require_relative '../lib/renamer'

describe "The manager object" do
  describe "executes the given objects in the right order" do
    describe "on initialization" do
      it "takes a path" do
        path = Dir.pwd
        SeriesNamer::Renamer.new( path ).path.must_equal path
      end

      it "makes sure the path is valid" do
        path = "/inexistend/path"

        proc {SeriesNamer::Renamer.new( path )}.must_raise(ArgumentError)
      end
    end

    describe "Naming the episodes" do
      def setup
        @path = "Burn Notice/Season 1"
        #@path = SeriesNamer::SeriesInfo.new("Burn Notice/Season 1","Burn Notice","Season 1")
        @expected_entries = ["S01E01 Burn Notice", "S01E02 Identity", "S01E03 Fight or Flight"]
        @given_entries = ["episode 1", "episode 2", "episode 3", ".", "..", "dir_something"]

        @dir_mock = MiniTest::Mock.new
        @dir_mock.expect(:exists?, true, [@path] )
        @dir_mock.expect(:entries, @given_entries, [@path])

        @file_utils_mock = MiniTest::Mock.new
        @file_utils_mock.expect(:mv, true, 
                               [File.join(@path, @given_entries.first), 
                                 File.join(@path, @expected_entries.first)])
      end


      it "gets all the entries" do
        expected_entries = ["episode 1", "episode 2", "episode 3"]

        VCR.use_cassette('burn_notice_season1_all_episodes') do
          renamer = SeriesNamer::Renamer.new( @path, @dir_mock, DummyFile.new )
          renamer.execute(@file_utils_mock)
          renamer.series_info.episodes("Season 1").must_equal expected_entries
        end

        @dir_mock.verify.must_equal true
      end

      it "it gets all the episode names per season" do

        VCR.use_cassette('burn_notice_season1_all_episodes') do
          renamer = SeriesNamer::Renamer.new( @path, @dir_mock, DummyFile.new )
          renamer.execute(@file_utils_mock)
          renamer.series_info.new_episodes(renamer.series_info.seasons.first).
            must_equal @expected_entries
        end

        @dir_mock.verify.must_equal true
      end

      it "renames all the episodes per season" do
        expected_entries = ["S01E01 Burn Notice"]
        given_entries = ["episode 1", ".", "..", "dir_something"]

        file_utils_mock = MiniTest::Mock.new
        file_utils_mock.expect(:mv, true, 
                               [File.join(@path, given_entries.first), 
                                 File.join(@path, expected_entries.first)])

        VCR.use_cassette('burn_notice_season1_all_episodes') do
          renamer = SeriesNamer::Renamer.new( @path, @dir_mock, DummyFile.new )
          renamer.execute(file_utils_mock)
        end

        @dir_mock.verify.must_equal true
        file_utils_mock.verify.must_equal true
      end
    end
  end
end


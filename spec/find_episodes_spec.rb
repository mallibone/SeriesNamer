require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/find_episodes'
require_relative '../lib/series_info'

require_relative 'spec_helper'

describe "Find existing episodes in path" do

  def setup
    @series_info = SeriesNamer::SeriesInfo.new("Burn Notice/Season 1", "Burn Notice", [1])
  end

  it "returns a list of all entries in a directory" do
    expected_entries = ["episode 1", "episode 2", "episode 3"]

    dir_mock = MiniTest::Mock.new
    dir_mock.expect(:exists?, true, [@series_info.path] )
    dir_mock.expect(:entries, Array.new(expected_entries), [@series_info.path])

    episode_finder = SeriesNamer::FindEpisodes.new(@series_info, dir_mock)

    episode_finder.results.must_equal expected_entries
    dir_mock.verify.must_equal true
  end

  it "ignores all directories or . and .. entries" do
    expected_entries = ["episode 1", "episode 2", "episode 3"]
    given_entries = Array.new(expected_entries) << "." << ".." << "dir_something"

    dir_mock = MiniTest::Mock.new
    dir_mock.expect(:exists?, true, [@series_info.path] )
    dir_mock.expect(:entries, Array.new(given_entries), [@series_info.path])

    episode_finder = SeriesNamer::FindEpisodes.new(@series_info, dir_mock, DummyFile.new)

    episode_finder.results.must_equal expected_entries
  end

end

class DummyFile
  attr_reader :count

  def initialize
    @count = 0
  end

  def directory?(path)
    @count += 1

    return false if @count <= 3

    return true
  end

  def join( path_1, path_2)
    return File.join(path_1, path_2)
  end
end

require 'minitest/spec'
require 'minitest/autorun'

require_relative 'spec_helper'

require_relative '../lib/parse_path'

describe SeriesNamer::ParsePath do
  it "Takes a path in form of a string" do
    path = Dir.pwd

    SeriesNamer::ParsePath.new(path).series_info.path.must_equal path
  end

  it "makes sure the path exists" do
    path = "path that does not exist"

    proc {SeriesNamer::ParsePath.new(path)}.must_raise(ArgumentError)
  end

  it "detects the series name from the path" do
    season = "season 1"
    series_name = "series_name"
    path = File.join(series_name, season)

    SeriesNamer::ParsePath.new(path, DummyDir.new).series_info.series.must_equal series_name
  end

  it "detects the season from the path" do
    season = "season 1"
    series_name = "series_name"
    path = File.join(series_name, season)

    SeriesNamer::ParsePath.new(path, DummyDir.new).series_info.seasons.first.must_equal season
  end

  it "looks for seasons if it isn't given in the path" do
    path = "series_name"
    expected_entries = ["season 1", "season 2", "season 23"]

    dir_mock = MiniTest::Mock.new
    dir_mock.expect(:exists?, true, path )
    dir_mock.expect(:entries, expected_entries<< "gnabber", path)

    assert dir_mock.verify

    SeriesNamer::ParsePath.new(path, dir_mock).seasons.must_equal expected_entries
  end

  it "returns a list foreach season for the series"
end


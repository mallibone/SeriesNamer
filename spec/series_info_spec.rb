require 'minitest/spec'
require 'minitest/autorun'

require_relative 'spec_helper'
require_relative '../lib/series_info'

describe "SeriesInfo" do
    def setup
      @path = "gnabber/schnabber"
      @series = "Burn Notice"
      @seasons = ["season 1","season 2"]
    end
  describe "When initializing it" do
    it "must store path, series and seasons" do

      series_info = SeriesNamer::SeriesInfo.new( @path, @series, @seasons )

      series_info.path.must_equal @path
      series_info.series.must_equal @series
      series_info.seasons.must_equal @seasons
    end

    it "is possible to pass in only one season" do
      seasons = "season 1"

      series_info = SeriesNamer::SeriesInfo.new( @path, @series, seasons )

      series_info.path.must_equal @path
      series_info.series.must_equal @series
      series_info.seasons.must_equal [seasons]
    end
  end

  describe "Adding original episode names" do
    it "is possible to add episodes" do
      episodes = ["episode1", "episode2"]

      series_info = SeriesNamer::SeriesInfo.new( @path, @series, @seasons )
      series_info.add_episodes(@seasons.first, episodes)

      series_info.episodes( @seasons.first ).must_equal episodes
    end

    it "is possible to add only one episode to a season" do
      episode = "episode1"

      series_info = SeriesNamer::SeriesInfo.new( @path, @series, @seasons )
      series_info.add_episodes(@seasons.first, episode)

      series_info.episodes( @seasons.first ).must_equal [episode]
    end
  end

  describe "Adding new episode names" do
    it "is possible to add new episode names" do
      episodes = ["episode1", "episode2"]

      series_info = SeriesNamer::SeriesInfo.new( @path, @series, @seasons )
      series_info.add_new_episodes(@seasons.first, episodes)

      series_info.new_episodes( @seasons.first ).must_equal episodes
    end
    it "is possible to add only one episode to a season" do
      episode = "episode1"

      series_info = SeriesNamer::SeriesInfo.new( @path, @series, @seasons )
      series_info.add_new_episodes(@seasons.first, episode)

      series_info.new_episodes( @seasons.first ).must_equal [episode]
    end
  end
end


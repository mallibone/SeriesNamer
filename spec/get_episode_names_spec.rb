require_relative 'spec_helper'

require 'minitest/spec'
require 'minitest/autorun'

describe "GetEpisodeNames" do

  it "takes the name of the series" do
    series_name = "Burn Notice"

    VCR.use_cassette('burn_notice') do
      SeriesNamer::GetEpisodeNames.new(series_name).series_name.must_equal series_name
    end
  end

  it "validates that the series exists" do
    VCR.use_cassette('burn_notice') do
      series_name = "Burn Notice"
      SeriesNamer::GetEpisodeNames.new(series_name).series_info.name.must_equal series_name
    end

  end

  it "throws an exception if the series does not exist" do
    VCR.use_cassette('sampsons') do
      series_name = "The Sampsons"
      proc {SeriesNamer::GetEpisodeNames.new(series_name)}.must_raise ArgumentError
    end
  end

  it "returns the name of an episode for a season" do
    series_name = "Burn Notice"
    season = 1
    episode = 3

    VCR.use_cassette('burn_notice_episode_1_3') do
      series_info = SeriesNamer::GetEpisodeNames.new(series_name)
      series_info.episode_name(season, episode).must_equal "S01E03 Fight or Flight"
    end
  end

  it "throws an error if the episode doesn't exist for a season" do
    series_name = "Burn Notice"
    season = 1
    episode = 33
    series_info = SeriesNamer::GetEpisodeNames.new(series_name)

    VCR.use_cassette('burn_notice_episode_1_33') do
      proc {series_info.episode_name(season, episode)}.must_raise ArgumentError
    end
  end
end

module SeriesNamer

  require 'tvdb_party'

  class GetEpisodeNames

    attr_reader :series_name, :series_info

    def initialize( series_name, tvdb_client = TvdbParty::Search.new("E923104E8EF02C8F") )
      @series_name = series_name
      @series_info = setup_client(tvdb_client)
    end

    def episode_name( season, episode )
      begin
        episode_info = @series_info.get_episode(season, episode)
      rescue VCR::Errors::UnhandledHTTPRequestError, SocketError
        episode_info = nil
      end


      raise ArgumentError, "Episode #{episode} Season #{season} not found." if episode_info.nil?

      episode_name = "S" + "%02d" % season + "E" + "%02d" % episode + " "
      episode_name << episode_info.name

      return episode_name
    end

    def episode_names( season )
      raise NotImplementedError
    end

    private

    def setup_client( tvdb_client )
      begin
        results = tvdb_client.search(@series_name).first
      rescue VCR::Errors::UnhandledHTTPRequestError, SocketError
        results = nil
      end

      raise ArgumentError, @series_name.to_s + " was not found" if results.nil?

      series = tvdb_client.get_series_by_id(results["seriesid"])

      return series
    end

  end
end


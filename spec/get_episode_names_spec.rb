require_relative 'spec_helper'

require 'minitest/spec'
require 'minitest/autorun'

require_relative '../lib/get_episode_names'

describe "GetEpisodeNames" do

  it "takes the name of the series" do
    series_info = SeriesNamer::SeriesInfo.new("Burn Notice/Season 1", "Burn Notice", "Season 1")

    VCR.use_cassette('burn_notice') do
      SeriesNamer::GetEpisodeNames.new(series_info).
        series_info.series.must_equal "Burn Notice"
    end
  end

  it "validates that the series exists" do
    series_info = SeriesNamer::SeriesInfo.new("Burn Notice/Season 1", "Burn Notice", "Season 1")
    VCR.use_cassette('burn_notice') do
      series_name = "Burn Notice"
      SeriesNamer::GetEpisodeNames.new(series_info).series_info.series.must_equal series_name
    end
  end

  it "throws an exception if the series does not exist" do
    series_info = SeriesNamer::SeriesInfo.new("The Sampsons/Season 1", "The Sampsons", "Season 1")
    VCR.use_cassette('sampsons') do
      proc {SeriesNamer::GetEpisodeNames.new(series_info)}.must_raise ArgumentError
    end
  end

  it "returns the name of an episode for a season" do
    series_info = SeriesNamer::SeriesInfo.new("Burn Notice/Season 1", "Burn Notice", "Season 1")
    series_name = "Burn Notice"
    season = 1
    episode = 3

    VCR.use_cassette('burn_notice_episode_1_3') do
      series_info = SeriesNamer::GetEpisodeNames.new(series_info)
      series_info.episode_name(season, episode).must_equal "S01E03 Fight or Flight"
    end
  end

  it "throws an error if the episode doesn't exist for a season" do
    series_info = SeriesNamer::SeriesInfo.new("Burn Notice/Season 1", "Burn Notice", "Season 1")
    series_name = "Burn Notice"
    season = 1
    episode = 33
    series_details = SeriesNamer::GetEpisodeNames.new(series_info)

    VCR.use_cassette('burn_notice_episode_1_33') do
      proc {series_details.episode_name(season, episode)}.must_raise ArgumentError
    end
  end

  it "is able to return a list of episode names if season and count are given" do
    series_info = SeriesNamer::SeriesInfo.new("Burn Notice/Season 1", "Burn Notice", "Season 1")
    episode_count = 11
    season = 1

    VCR.use_cassette('burn_notice_season1_all_episodes') do
      series_info = SeriesNamer::GetEpisodeNames.new(series_info)
      #series_info.episode_names(season, episode_count).must_equal ["S01E03 Fight or Flight"]
      series_info.episode_names(season, episode_count).must_equal ["S01E01 Burn Notice", 
        "S01E02 Identity", "S01E03 Fight or Flight", "S01E04 Old Friends", 
        "S01E05 Family Business", "S01E06 Unpaid Debts", "S01E07 Broken Rules", 
        "S01E08 Wanted Man", "S01E09 Hard Bargain", "S01E10 False Flag", 
        "S01E11 Dead Drop (1)"]
    end
  end
end

require 'minitest/spec'
require 'minitest/autorun'

require 'vcr'

describe "GetEpisodeNames" do
  #before do
  #  VCR.insert_cassette 'tvdb'
  #end

  #after do
  #  VCR.eject_cassette
  #end

  it "takes the name of the series" do
    series_name = "Burn Notice"

    SeriesNamer::GetEpisodeNames.new(series_name).series_name.must_equal series_name
  end

  it "validates that the series exists" do
    series_name = "Burn Notice"
    SeriesNamer::GetEpisodeNames.new(series_name).series_info.name.must_equal series_name

    series_name = "The Sampsons"
    proc {SeriesNamer::GetEpisodeNames.new(series_name)}.must_raise ArgumentError
  end

  it "returns the name of an episode for a season" do
    series_name = "Burn Notice"
    season = 1
    episode = 3
    series_info = SeriesNamer::GetEpisodeNames.new(series_name)

    series_info.episode_name(season, episode).must_equal "Fight or Flight"
  end

  it "throws an error if the episode doesn't exist for a season" do
    series_name = "Burn Notice"
    season = 1
    episode = 33
    series_info = SeriesNamer::GetEpisodeNames.new(series_name)

    proc {series_info.episode_name(season, episode)}.must_raise ArgumentError
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
      episode_info = @series_info.get_episode(season, episode)

      raise ArgumentError, "Episode #{episode} Season #{season} not found." if episode_info.nil?

      return episode_info.name
    end

    def episode_names( season )
      
    end

    private

    def setup_client( tvdb_client )
      results = tvdb_client.search(@series_name).first

      raise ArgumentError, @series_name.to_s + " was not found" if results.nil?

      series = tvdb_client.get_series_by_id(results["seriesid"])

      return series
    end

  end
end

class DummyTvdbParty
  def search( series_name)
    return @burn_notice if series_name.lower_case == "burn notice"
    return nil
  end

  @burn_notice = {"seriesid"=>"80270", "language"=>"en", "SeriesName"=>"Burn Notice", "banner"=>"graphical/80270-g12.jpg", "Overview"=>"Covert intelligence operative Michael Westen has been punched, kicked, choked and shot. Now he's being burned, and someone's going to pay! When Michael receives a \"burn notice\", blacklisting him from the intelligence community and compromising his very identity, he must track down a faceless nemesis without getting himself killed in the process. Meanwhile, Michael is forced to double as a private investigator on the dangerous streets of Miami in order to survive. Fully loaded with sly humor, Burn Notice is a fresh spin on the spy genre with plenty of precarious twists to keep you guessing and enough explosive action to keep you riveted!", "FirstAired"=>"2007-06-28", "IMDB_ID"=>"tt0810788", "zap2it_id"=>"EP00924844", "id"=>"80270"}

end


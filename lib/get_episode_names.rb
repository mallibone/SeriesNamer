module SeriesNamer

  require 'tvdb_party'
  require 'yaml'

  class GetEpisodeNames

    attr_reader :series_info, :tvdb_client

    def initialize( series_info, tvdb_search = TvdbParty::Search)
      tvdb_id = YAML.load_file("data/tvdb_info.yml")["id"]
      tvdb_client = tvdb_search.new(tvdb_id)
      @series_info = series_info
      @tvdb_client = setup_client(tvdb_client)
    end

    def episode_name( season, episode )
      begin
        episode_info = @tvdb_client.get_episode(season, episode)
      rescue VCR::Errors::UnhandledHTTPRequestError, SocketError
        episode_info = nil
      end


      raise ArgumentError, "Episode #{episode} Season #{season} not found." if episode_info.nil?

      return format_episode_name(episode_info.name, season, episode)
    end

    def episode_names( season, episode_cnt )
      episode_names = []

      episode_cnt.times do |cnt|
        episode_names << episode_name(season, cnt+1)
      end

      return episode_names
    end

    private

    def setup_client( tvdb_client )
      begin
        results = tvdb_client.search(@series_info.series).first
      # VCR is used for testing
      rescue VCR::Errors::UnhandledHTTPRequestError, SocketError
        results = nil
      end

      raise ArgumentError, @series_info.series.to_s + " was not found" if results.nil?

      return tvdb_client.get_series_by_id(results["seriesid"])
    end

    def format_episode_name(unformated_episode_name, season, episode)
      episode_name = "S" + "%02d" % season + "E" + "%02d" % episode + " "
      episode_name << unformated_episode_name

      return episode_name
    end

  end
end


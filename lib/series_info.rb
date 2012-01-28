module SeriesNamer
  class SeriesInfo
    attr_reader :path, :series, :seasons

    def initialize( path, series, seasons )
      @path = path
      @series = series

      @seasons = Hash.new
      if( seasons.kind_of?( Array ) )
        seasons.each{ |season| @seasons[season] = Array.new }
      else
        @seasons[seasons] = Array.new
      end
    end

    # Get all seasons
    def seasons
      return @seasons.keys
    end

    # Get all episodes for a season
    def episodes( season )
      return @seasons[season]
    end

    # add multiple episdoes to a season
    def add_episodes( season, episodes)
      @seasons[season].concat(episodes)
      @seasons[season].flatten
    end

    # add single episode to season
    def add_episode( season, episode)
      @seasons[season] << episode
      @seasons[season].flatten
    end
  end
end

module SeriesNamer
  class SeriesInfo
    attr_reader :path, :series, :seasons

    def initialize( path, series, *seasons )
      @path = path
      @series = series

      @seasons = Hash.new
      seasons.flatten.each{ |season| @seasons[season] = [Array.new,Array.new] }
    end

    # Get all seasons
    def seasons
      return @seasons.keys
    end

    # Get original episode names for a season
    def episodes( season )
      return @seasons[season].first.flatten
    end
    
    # Get new episode names for a season
    def new_episodes( season )
      return @seasons[season][1].flatten
    end

    # add single/multiple episdoes to a season
    def add_episodes( season, *episodes)
      @seasons[season].first.concat(episodes)
      @seasons[season].flatten
    end
    
    # add single/multiple episdoes to a season
    def add_new_episodes( season, *episodes)
      @seasons[season][1].concat(episodes)
      @seasons[season].flatten
    end
  end
end

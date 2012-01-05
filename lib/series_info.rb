module SeriesNamer
  class SeriesInfo
    attr_reader :path, :series, :seasons

    def initialize( path, series, seasons )
      @path = path
      @series = series

      @seasons = []
      @seasons << seasons
      @seasons.flatten!
    end
  end
end

module SeriesNamer
  require_relative 'series_info'
  require_relative 'validation/path'
  class ParsePath
    attr_reader :series_info
    @directory
    @file

    def initialize( path, directory = Dir, file = File )

      @directory = directory
      @file = file

      # If invalid raises an exception
      raise ArgumentError, "Path #{path} doesn't exist." unless path_valid?(path)

      series = @file.basename( @file.dirname( path ) )

      seasons = get_seasons( path )

      @series_info = SeriesInfo.new( path, series, seasons )
    end

    private

    def path_valid?(path)
      return @directory.exists?( path )
    end

    def get_seasons( path )
      seasons = []

      if valid_season_name?( @file.basename(path) )
        seasons << @file.basename(path)
      else
        @directory.entries(path).each do |entry| 
          seasons << entry if valid_season_name?( entry )
        end
      end

      return seasons
    end

    # A valid season name: name XX
    def valid_season_name?( name )

      return name.downcase =~ /^season /

    end
  end
end

module SeriesNamer
  require_relative 'series_info'
  require_relative 'validation/path'
  class ParsePath
    attr_reader :series_info
    @directory

    def initialize( path, directory = Dir )

      @directory = directory

      # If invalid raises an exception
      raise ArgumentError, "Path #{path} doesn't exist." unless path_valid?(path)

      series = File.basename( File.dirname( path ) )

      seasons = []
      seasons << File.basename(path)

      @series_info = SeriesInfo.new( path, series, seasons )
    end

    private

    def path_valid?(path)
      return @directory.exists?( path )
    end
  end
end

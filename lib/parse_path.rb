module SeriesNamer
  require_relative 'series_info'
  require_relative 'validation/path'
  class ParsePath
    attr_reader :series_info

    def initialize( path, path_verifier = Validation::Path )

      # If invalid raises an exception
      path_verifier.exists?( path )

      path = path

      series = File.basename( File.dirname( path ) )

      seasons = []
      seasons << File.basename(path)

      @series_info = SeriesInfo.new( path, series, seasons )
    end
  end
end

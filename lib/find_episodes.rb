module SeriesNamer
  require_relative '../lib/series_info'
  class FindEpisodes

    attr_reader :series_info

    @directory = nil  #usually defaults to Rubys Dir
    @file = nil       #usually defaults to Rubys File

    def initialize( series_info, directory = Dir, file = File)
      unless directory.exists?( series_info.path )
        raise ArgumentError, "Path #{path} doesn't exist." 
      end

      @directory = directory
      @file = file

      @series_info = series_info
    end

    def results
      result = []

      @directory.entries( @series_info.path ).each do |entry| 
        result << entry unless @file.directory?(@file.join(@series_info.path, entry))
      end

      return result
    end

    def path
      return @series_info.path
    end

    private

    def get_entries_for_season( season_path )

    end

  end
end

module SeriesNamer
  class FindEpisodes

    attr_reader :path

    @directory  #usually defaults to Rubys Dir
    @file       #usually defaults to Rubys File

    def initialize( path, directory = Dir, file = File)
      @directory = directory
      @file = file

      raise ArgumentError, "Path #{path} doesn't exist." unless @directory.exists?( path )

      @path = path
    end

    def results
      result = []

      @directory.entries( path ).each do |entry| 
        result << entry unless @file.directory?(@file.join(path, entry))
      end

      return result
    end

  end
end

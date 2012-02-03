module SeriesNamer

  require_relative 'find_episodes'
  require_relative 'get_episode_names'
  require_relative 'parse_path'
  require_relative 'rename_episodes'

  class Renamer

    attr_reader :path, :series_info

    @dir #defaults to ruby dir used for tests
    @file #defaults to ruby file used for tests

    def initialize( path, dir = Dir, file = File )
      @dir = dir

      raise ArgumentError, "Path #{path} does not exist" unless @dir.exists?( path )

      @path = path
      @file = file
    end

    def execute( file_utils = FileUtils )
      @series_info = ParsePath.new(@path, @dir, @file).series_info

      @series_info.add_episodes(@series_info.seasons.first, get_dir_entries)

      @series_info.add_new_episodes(
        @series_info.seasons.first, get_episode_names
      )

      rename_episodes(file_utils)

    end

    private

    def get_dir_entries
      return FindEpisodes.new(@series_info, @dir, @file).results
    end

    def get_episode_names
      return GetEpisodeNames.new(@series_info).episode_names(
        @series_info.seasons.first[@series_info.seasons.first.size-1].to_i, 
        @series_info.episodes(@series_info.seasons.first).size )
    end

    def rename_episodes(file_utils)

      @series_info.seasons.each do |season|
        current_episode_names = @series_info.episodes(season)
        new_episode_names = @series_info.new_episodes(season)

        RenameEpisodes.new(@series_info.path, 
                           current_episode_names, 
                           new_episode_names, 
                           @dir).now(file_utils)
      end

    end

  end

end


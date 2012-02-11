module SeriesNamer
  class RenameEpisodes

    require 'fileutils'

    attr_reader :path, :current_names, :new_names
    @directory = nil # default Dir may be set differently for tests

    def initialize( path, current_names, new_names, directory = Dir )

      @directory = directory

      # Raises ArgumentError if invalid
      check_argument_validity( path, current_names, new_names )

      @path = path

      @current_names = current_names
      @new_names = new_names
    end

    def now( file_utils = FileUtils )
      current_names.each_with_index do |episode, i|
        renamed_episode = new_names[i] + File.extname(episode)
        file_utils.mv(File.join(path, episode), File.join(path, renamed_episode))
      end

      return @directory.entries(@path)
    end

    private

    def check_argument_validity( path, current_names, new_names )
      raise ArgumentError, "Path #{path} not found" unless @directory.exists?( path )

      unless current_names.length == new_names.length
        raise ArgumentError, "Expected equal length for current and new names"
      end

      unless current_names.length > 0 && new_names.length > 0
        raise ArgumentError, "Expected equal length for current and new names"
      end

      check_episode_exists( path, current_names )
    end

    def check_episode_exists( path, current_names )
      dir_entries = @directory.entries( path )
      current_names.each do |e|
        unless  dir_entries.detect{|d| d == e}
          raise ArgumentError, "Could not find #{e} in #{path}"
        end
      end
    end

  end
end


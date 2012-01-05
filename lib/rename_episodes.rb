module SeriesNamer
  class RenameEpisodes

    require 'fileutils'

    attr_reader :path, :current_names, :new_names

    def initialize( path, current_names, new_names, dir_check = Dir )
      # Raises ArgumentError if invalid
      check_argument_validity( path, current_names, new_names, dir_check )

      @path = path

      @current_names = current_names
      @new_names = new_names
    end

    def now( file_utils = FileUtils )
      current_names.each_with_index do |episode, i|
        renamed_episode = new_names[i]
        file_utils.mv(File.join(path, episode), File.join(path, renamed_episode))
      end
    end

    private

    def check_argument_validity( path, current_names, new_names, dir_check )
      SeriesNamer::Validation::Path.exists?( path )

      unless current_names.length == new_names.length
        raise ArgumentError, "Expected equal length for current and new names"
      end

      unless current_names.length > 0 && new_names.length > 0
        raise ArgumentError, "Expected equal length for current and new names"
      end

      check_episode_exists( path, current_names, dir_check )
    end

    def check_episode_exists( path, current_names, dir_check )
      dir_entries = dir_check.entries( path )
      current_names.each do |e|
        unless  dir_entries.detect{|d| d == e}
          raise ArgumentError, "Could not find #{e} in #{path}"
        end
      end
    end

  end
end


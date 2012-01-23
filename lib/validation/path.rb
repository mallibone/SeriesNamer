module SeriesNamer
  module Validation
    class Path
      def self.exists?( path, path_verifier = Dir )
        #raise ArgumentError, "Path #{path} does not exist." unless path_verifier.exists?(path)
      end
    end
  end
end

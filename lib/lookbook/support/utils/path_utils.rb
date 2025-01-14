module Lookbook
  module PathUtils
    class << self
      def to_absolute(path)
        File.absolute_path(path.to_s, Rails.root)
      end

      def to_lookup_path(file_path)
        path = file_path.to_s.downcase

        directory_path = File.dirname(path)
        directory_path = nil if directory_path.start_with?(".")

        file_name = File.basename(path).split(".").first

        segments = [*directory_path&.split("/"), file_name].compact
        stripped_segments = segments.map! do |segment|
          PositionPrefixParser.call(segment).last.tr("-", "_")
        end

        to_path(stripped_segments)
      end

      def to_path(*args)
        args.flatten.compact.map(&:to_s).join("/")
      end

      def normalize_paths(paths, allow_root: false)
        Array(paths).map do |path|
          full_path = to_absolute(path)
          if File.exist?(full_path)
            full_path if allow_root || !root_path?(full_path)
          end
        end.compact.uniq
      end

      def root_path?(path)
        Rails.application.root.to_s == path.to_s
      end

      def strip_slashes(path)
        path.to_s.gsub(/\A\/|\/\z/, "")
      end
    end
  end
end

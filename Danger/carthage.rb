
require "danger"

module Danger
  module Plugins
    class Carthage < Plugin

      def execute
        if added_or_deleted_sources.empty?() then return end
        if project_modified then return end
        fail("Source files have been added or removed. Execute `bundle exec rake generate_carthage_project` to regenerate the Carthage.xcodeproj")
      end

      private

      def added_or_deleted_sources
         (git.added_files + git.deleted_files).select {|path| path.include?("Sources/xcproj")}
      end

      def project_modified
        !git.modified_files.select {|path| path.include?("Carthage.xcodeproj")}.empty?()
      end

    end
  end
end

require "rails/generators/named_base"

module Rails
  module Generators
    class AdrGenerator < ::Rails::Generators::NamedBase
      # desc "Generate a new Architecture Decision Record in docs/adr"
      source_root File.expand_path("templates", __dir__)

      def create_adr
        @adr_dir = Rails.root.join('doc', 'adr')
        @padded_number = sprintf("%03d", get_new_number)
        slug = name.downcase.underscore.gsub(/[^a-zA-Z0-9]/, "-")
        @title = name.titlecase
        template "adr.md.erb", @adr_dir.join("#{@padded_number}-#{slug}.md"), binding
      end

      private
      def get_new_number
        FileUtils.mkdir_p(@adr_dir)
        new_number = 0
        Dir.glob(@adr_dir.join "*.md").each do |adr_file|
          number = File.basename(adr_file).split('-').first.to_i
          new_number = [new_number, number].max
        end
        new_number += 1
      end
    end
  end
end

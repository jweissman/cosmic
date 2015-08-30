require 'forwardable'
module Cosmic
  class Dictionary
    extend Forwardable

    def_delegators :@entries, :sample, :each, :each_with_index, :length

    attr_accessor :entries
    def initialize(entries=['hello'])
      @entries = entries
    end

    def merged_with(new_entries)
      @entries = (@entries + new_entries).uniq
    end

    class << self
      def of(taxonomy)
        dictionaries[taxonomy] ||= Dictionary.new(load_entries(taxonomy))
      end

      def exists?(taxonomy)
        File.exists? taxonomy_path(taxonomy)
      end

      private

      def dictionaries
        @dictionaries ||= {}
      end

      def path_to_data_files
        @path_to_data_files ||= "data/"
      end

      def taxonomy_path(taxonomy)
        "#{path_to_data_files}#{taxonomy}.txt"
      end

      def load_entries(taxonomy)
        path  = taxonomy_path(taxonomy)
        file  = File.open(path)
        lines = file.read.each_line
        lines.map(&:strip).to_a 
      end
    end
  end
end

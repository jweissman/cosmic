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
      def of(taxonomy, s=Cosmic.scheme)
        dictionaries[s] ||= {}
        dictionaries[s][taxonomy] ||= Dictionary.new(load_entries(taxonomy, s))
      end

      def exists?(taxonomy)
        File.exists? taxonomy_path(taxonomy)
      end

      private

      def dictionaries
        @dictionaries ||= {}
      end

      def path_to_data_files(s)
        scheme_path = "#{s}/"
        "data/#{scheme_path}"
      end

      def taxonomy_path(taxonomy,s=Cosmic.scheme)
        "#{path_to_data_files(s)}#{taxonomy}.txt"
      end

      def load_entries(taxonomy, s=Cosmic.scheme)
        path  = taxonomy_path(taxonomy, s)
        raise "Missing dictionary '#{taxonomy}' (`touch #{path}`)" unless File.exists?(path)
        file  = File.open(path)
        lines = file.read.each_line
        lines.map(&:strip).to_a 
      end
    end
  end
end

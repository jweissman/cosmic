module Cosmic
  class Dictionary
    attr_accessor :entries
    def initialize(entries=['hello'])
      @entries = entries
    end

    def merged_with(*new_entries)
      @entries = (@entries + new_entries).flatten.uniq
    end

    class << self
      def dictionaries
        @dictionaries ||= {}
      end

      def path_to_data_files
        @path_to_data_files ||= "data/"
      end

      def of(taxonomy)
        dictionaries[taxonomy] ||= Dictionary.new(load_entries(taxonomy))
      end

      def load_entries(taxonomy)
        path = "#{path_to_data_files}#{taxonomy}.txt"
        file = File.open(path)

        lines = file.read.each_line

        lines.map(&:strip).to_a 
      end
    end
  end
end

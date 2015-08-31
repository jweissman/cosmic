module Cosmic

  def self.scheme; @_scheme ||= ENV['SCHEME'] || :future end
  #def self.scheme=(s); @_scheme = s; end

  # class SchemeManager
  #   def initialize(s=:future)
  #     @_scheme = s
  #   end
  # end


  # def self.scheme
  #   @scheme ||= :future 
  # end

  # def self.scheme=(s)
  #   binding.pry
  #   puts "=== BOOTSTRAP NEW SCHEME!"
  #   @scheme = s
  #   bootstrap(Dictionary.of(:hierarchy_terms).entries)
  # end

  # def self.schemes
  #   %i( future ) 
  # end
end

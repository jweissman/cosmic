require 'active_support/inflector'

require 'cosmic/version'
require 'cosmic/dictionary'

require 'cosmic/name'
require 'cosmic/printer'
require 'cosmic/model'

require 'cosmic/leaf'
require 'cosmic/root'
require 'cosmic/celestial_body'
require 'cosmic/terrestrial_entity'

require 'cosmic/profession'
require 'cosmic/bootstrap'

module Cosmic
  bootstrap(Dictionary.of(:hierarchy_terms).entries)
end

require 'cosmic/building'
require 'cosmic/person'


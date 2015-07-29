require "./getter"
require "./setter"

module Pendant::Property
  include Pendant::Getter
  include Pendant::Setter
end

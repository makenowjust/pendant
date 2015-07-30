require "./getter"
require "./setter"

module Pendant::Property
  include Pendant::Getter
  include Pendant::Setter

  # It returns available keys.
  #
  # A method of keys have no argument (except `keys`),
  # or a name of keys ends with '=' and length of its arguments is `1` (except `[]=`).
  def keys; end
end

require "../src/pendant"

class Accessory
  # define properties and initializer
  property name, owner

  def initialize(@name, @owner); end

  # include pendant module
  # it defines `Accessory#[]`, `Accessory#[]?`, `Accessory#[]=` and
  # `Accessory#has_key?` automatically.
  include Pendant::Property
end

# create a new accessory
pendant = Accessory.new(
  name  = "pendant",
  owner = "Alice",
)

# it can access via `[]` method
puts pendant[:name]
puts pendant["owner"]

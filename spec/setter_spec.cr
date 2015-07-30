require "./spec_helper"

class AccessorySetter
  property a, b

  def initialize(@a, @b); end

  def c=(c : {Int32, Int32})
    @a, @b = c
  end

  def c=(c); end

  include Pendant::Setter
end

describe Pendant::Setter do
  it "should not have `[]` method" do
    AccessorySetter.new(1, 2).responds_to?(:[]).should be_false
  end

  it "should not have `[]?` method" do
    AccessorySetter.new(1, 2).responds_to?(:[]?).should be_false
  end

  it "should set a value via `[]=` with Symbol" do
    accessory = AccessorySetter.new(0, 0)

    accessory[:a] = 1
    accessory.a.should eq 1
    accessory[:b] = 2
    accessory.b.should eq 2
    accessory[:c] = {3, 4}
    accessory.a.should eq 3
    accessory.b.should eq 4
  end

  it "should set a value via `[]=` with String" do
    accessory = AccessorySetter.new(0, 0)

    accessory["a"] = 1
    accessory.a.should eq 1
    accessory["b"] = 2
    accessory.b.should eq 2
    accessory["c"] = {3, 4}
    accessory.a.should eq 3
    accessory.b.should eq 4
  end

  it "should raise an error via `[]=` with no existing Symbol" do
    accessory = AccessorySetter.new(1, 2)
    expect_raises KeyError do
      accessory[:d] = 0
    end
  end

  it "should raise an error via `[]=` with no existing String" do
    accessory = AccessorySetter.new(1, 2)
    expect_raises KeyError do
      accessory["d"] = 0
    end
  end

  it "should return keys as String list" do
    accessory = AccessorySetter.new(1, 2)
    accessory.keys.sort.should eq %w(a b c)
  end
end

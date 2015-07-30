require "./spec_helper"

class AccessoryProperty
  property a, b

  def initialize(@a, @b); end

  def c
    {@a, @b}
  end

  def c=(c : {Int32, Int32})
    @a, @b = c
  end

  def c=(c); end

  def d
    [@a, @b]
  end

  include Pendant::Property
end

class AccessoryProperty2 < AccessoryProperty
  property e

  def initialize(@a, @b, @e); end
end

describe Pendant::Property do
  it "should return a value via `[]` with Symbol" do
    accessory = AccessoryProperty.new(1, 2)
    accessory[:a].should eq 1
    accessory[:b].should eq 2
    accessory[:c].should eq({1, 2})
    accessory[:d].should eq [1, 2]
  end

  it "should return a value via `[]` with String" do
    accessory = AccessoryProperty.new(1, 2)
    accessory["a"].should eq 1
    accessory["b"].should eq 2
    accessory["c"].should eq({1, 2})
    accessory["d"].should eq [1, 2]
  end

  it "should raise an error via `[]` with no existing Symbol" do
    accessory = AccessoryProperty.new(1, 2)
    expect_raises KeyError do
      accessory[:e]
    end
  end

  it "should raise an error via `[]` with no existing String" do
    accessory = AccessoryProperty.new(1, 2)
    expect_raises KeyError do
      accessory["e"]
    end
  end

  it "should return a value via `[]?` with Symbol" do
    accessory = AccessoryProperty.new(1, 2)
    accessory[:a]?.should eq 1
    accessory[:b]?.should eq 2
    accessory[:c]?.should eq({1, 2})
    accessory[:d]?.should eq [1, 2]
  end

  it "should return a value via `[]?` with String" do
    accessory = AccessoryProperty.new(1, 2)
    accessory["a"]?.should eq 1
    accessory["b"]?.should eq 2
    accessory["c"]?.should eq({1, 2})
    accessory["d"]?.should eq [1, 2]
  end

  it "should not raise an error via `[]?` with no existing Symbol" do
    accessory = AccessoryProperty.new(1, 2)
    accessory[:e]?.should be_nil
  end

  it "should not raise an error via `[]?` with no existing String" do
    accessory = AccessoryProperty.new(1, 2)
    accessory["e"]?.should be_nil
  end

  it "should set a value via `[]=` with Symbol" do
    accessory = AccessoryProperty.new(0, 0)

    accessory[:a] = 1
    accessory.a.should eq 1
    accessory[:b] = 2
    accessory.b.should eq 2
    accessory[:c] = {3, 4}
    accessory.a.should eq 3
    accessory.b.should eq 4
  end

  it "should set a value via `[]=` with String" do
    accessory = AccessoryProperty.new(0, 0)

    accessory["a"] = 1
    accessory.a.should eq 1
    accessory["b"] = 2
    accessory.b.should eq 2
    accessory["c"] = {3, 4}
    accessory.a.should eq 3
    accessory.b.should eq 4
  end

  it "should raise an error via `[]=` with no existing Symbol" do
    accessory = AccessoryProperty.new(1, 2)
    expect_raises KeyError do
      accessory[:d] = 0
    end
  end

  it "should raise an error via `[]=` with no existing String" do
    accessory = AccessoryProperty.new(1, 2)
    expect_raises KeyError do
      accessory["d"] = 0
    end
  end

  it "should return existing keys as String list" do
    accessory = AccessoryProperty.new(1, 2)
    accessory.keys.sort.should eq %w(a b c d)
  end

  it "should return existing keys as String list even if inherited" do
    accessory = AccessoryProperty2.new(1, 2, 3)
    accessory.keys.sort.should eq %w(a b c d e)
  end
end

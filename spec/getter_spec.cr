require "./spec_helper"

class AccessoryGetter
  getter a, b

  def initialize(@a, @b); end

  def c
    {@a, @b}
  end

  def d
    [@a, @b]
  end

  include Pendant::Getter
end

describe Pendant::Getter do
  it "should not have `[]=` method" do
    AccessoryGetter.new(1, 2).responds_to?(:[]=).should be_false
  end

  it "should return a value via `[]` with Symbol" do
    accessory = AccessoryGetter.new(1, 2)
    accessory[:a].should eq 1
    accessory[:b].should eq 2
    accessory[:c].should eq({1, 2})
    accessory[:d].should eq [1, 2]
  end

  it "should return a value via `[]` with String" do
    accessory = AccessoryGetter.new(1, 2)
    accessory["a"].should eq 1
    accessory["b"].should eq 2
    accessory["c"].should eq({1, 2})
    accessory["d"].should eq [1, 2]
  end

  it "should raise an error via `[]` with no existing Symbol" do
    accessory = AccessoryGetter.new(1, 2)
    expect_raises MissingKey do
      accessory[:e]
    end
  end

  it "should raise an error via `[]` with no existing String" do
    accessory = AccessoryGetter.new(1, 2)
    expect_raises MissingKey do
      accessory["e"]
    end
  end

  it "should return a value via `[]?` with Symbol" do
    accessory = AccessoryGetter.new(1, 2)
    accessory[:a]?.should eq 1
    accessory[:b]?.should eq 2
    accessory[:c]?.should eq({1, 2})
    accessory[:d]?.should eq [1, 2]
  end

  it "should return a value via `[]?` with String" do
    accessory = AccessoryGetter.new(1, 2)
    accessory["a"]?.should eq 1
    accessory["b"]?.should eq 2
    accessory["c"]?.should eq({1, 2})
    accessory["d"]?.should eq [1, 2]
  end

  it "should not raise an error via `[]?` with no existing Symbol" do
    accessory = AccessoryGetter.new(1, 2)
    accessory[:e]?.should be_nil
  end

  it "should not raise an error via `[]?` with no existing String" do
    accessory = AccessoryGetter.new(1, 2)
    accessory["e"]?.should be_nil
  end

  it "should return existing keys as String list" do
    accessory = AccessoryGetter.new(1, 2)
    accessory.keys.sort.should eq %w(a b c d)
  end
end

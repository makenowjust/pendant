require "./spec_helper"

describe Pendant do
  it "sample.cr" do
    {{ run("./sample.cr").stringify }}.should eq "pendant
Alice
"
  end
end

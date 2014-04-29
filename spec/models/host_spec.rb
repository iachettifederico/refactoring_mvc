require "spec_helper"

describe Host do
  describe "twitter handle" do
    it "adds an @ character if it's not there" do
      host = Host.new(twitter_handle: "the_handle")
      host.twitter_handle.should == "@the_handle"
    end

    it "leaves the @ character if it's there" do
      host = Host.new(twitter_handle: "@the_handle")
      host.twitter_handle.should == "@the_handle"
    end
  end

  describe "twitter url" do
    it "returns the correct twitter url" do
      host = Host.new(twitter_handle: "@the_handle")
      host.twitter_url.should == "http://twitter.com/the_handle"
    end
  end

end

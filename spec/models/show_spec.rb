require 'spec_helper'

describe Show do
  describe "imports wxr files" do
    let(:show) { FactoryGirl.build(:show) }

    let(:wxr_file) {
      file_path = File.dirname(__FILE__) + "/../fixtures/rubyrogues.wordpress.2012-10-20.xml"
      File.open(file_path)
    }

  end

  describe "#url" do
    it "adds http:// to the domain" do
      show = FactoryGirl.build(:show, domain: "my.podcast.com")
      show.url.should == "http://my.podcast.com"
    end

    it "is empty if the domain is" do
      show = FactoryGirl.build(:show, domain: nil)
      show.url.should == ""
    end
  end

  describe "#rss_url" do
    it "adds http:// to the domain" do
      show = FactoryGirl.build(:show, domain: "my.podcast.com")
      show.rss_url.should == "http://my.podcast.com/podcast.rss"
    end

    it "is empty if the url is" do
      show = FactoryGirl.build(:show, domain: nil)
      show.rss_url.should == ""
    end
  end

  describe "#transcripts_rss_url" do
    it "adds http:// to the domain" do
      show = FactoryGirl.build(:show, domain: "my.podcast.com")
      show.transcripts_rss_url.should == "http://my.podcast.com/transcripts.rss"
    end

    it "is empty if the url is" do
      show = FactoryGirl.build(:show, domain: nil)
      show.transcripts_rss_url.should == ""
    end
  end
end

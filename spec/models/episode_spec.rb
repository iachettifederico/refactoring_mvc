require 'spec_helper'

describe Episode do
  context "publication date" do
    it "accept dates in mm/dd/yy and pase them properly" do
      episode = FactoryGirl.build(:episode)
      episode.published_at = "12/06/2013"

      episode.published_at.should == Date.parse("06 Dec 2013")
    end

    it "accept dates in mm/dd/yy and pase them properly" do
      episode = FactoryGirl.build(:episode)
      episode.published_at = DateTime.parse("06 Dec 2013")

      episode.published_at.should == Date.parse("06 Dec 2013")
    end

    it "accept dates in mm/dd/yy and pase them properly" do
      episode = FactoryGirl.build(:episode)
      episode.published_at = Date.parse("06 Dec 2013")

      episode.published_at.should == Date.parse("06 Dec 2013")
    end
  end

  context "next and previous episodes" do
    let!(:show) { FactoryGirl.create(:show, title: "Show", domain: "show.com") }
    let!(:show2) { FactoryGirl.create(:show, title: "Another Show", domain: "another_show.com") }

    let!(:first) { FactoryGirl.create( :episode,
                                      title: "First Episode",
                                      show_id: show.id,
                                      published_at: DateTime.new(2014, 1, 1)) }

    let!(:first2) { FactoryGirl.create( :episode,
                                       title: "First Episode of another Show",
                                       show_id: show2.id,
                                       published_at: DateTime.new(2014, 1, 8)) }

    let!(:second) { FactoryGirl.create( :episode,
                                       title: "Second Episode",
                                       show_id: show.id,
                                       published_at: DateTime.new(2014, 1, 8)) }

    let!(:third) { FactoryGirl.create( :episode,
                                      title: "Third Episode",
                                      show_id: show.id,
                                      published_at: DateTime.new(2014, 1, 15)) }


    it "returns the previous episode" do
      first.previous.should  == nil
      second.previous.should == first
      third.previous.should  == second
    end

    it "returns the next episode" do
      first.next.should  == second
      second.next.should == third
      third.next.should  == nil
    end
  end

  context "most popular episodes" do
    let!(:episode1) { FactoryGirl.create(:episode, title: "Episode 1", published_at: Date.today - 5.days) }
    let!(:episode2) { FactoryGirl.create(:episode, title: "Episode 2", published_at: Date.today - 4.days) }
    let!(:episode3) { FactoryGirl.create(:episode, title: "Episode 3", published_at: Date.today - 3.days) }
    let!(:episode4) { FactoryGirl.create(:episode, title: "Episode 4", published_at: Date.today - 2.days) }
    let!(:episode5) { FactoryGirl.create(:episode, title: "Episode 5", published_at: Date.today - 1.days) }


    it "returns the most downloaded episodes" do
      keen_gateway = double(most_popular_episodes: {
          "episode-1" => 4,
          "episode-2" => 8,
          "episode-3" => 6,
          "episode-4" => 6,
          "episode-5" => 2,
        })
      result = Episode.most_popular(keen_gateway: keen_gateway)

      result.should == [
          episode2,
          episode4,
          episode3,
          episode1,
          episode5,
        ]
    end

    it "returns the three most downloaded episodes" do
       keen_gateway = double(most_popular_episodes: {
          "episode-1" => 4,
          "episode-2" => 8,
          "episode-3" => 6,
          "episode-4" => 6,
          "episode-5" => 2,
        })
      result = Episode.most_popular(count: 3, keen_gateway: keen_gateway)

      result.should == [
          episode2,
          episode4,
          episode3,
        ]
    end
  end

  describe "#show_slug=" do
    let!(:show) { FactoryGirl.create(:show, slug: "the-slug") }

    it "sets the show" do
      episode = Episode.new
      episode.show_slug = "the-slug"

      episode.show.should == show
    end
  end
end

require 'spec_helper'

describe Episode do
  it "generates a slug when the episode is saved" do
    s = Show.create(title: "Ruby Rogues")
    e = s.episodes.new(title: "kids are fun", description: "abcdefg")
    e.slug.should be_blank
    e.save
    e.slug.should_not be_blank
    e.slug.should == "kids-are-fun"
  end

  it "slugs only have one consecutive -" do
    s = Show.create(title: "Ruby Rogues")
    e = s.episodes.new(title: "kids are.? fun", description: "abcdefg")
    e.save
    e.slug.should == "kids-are-fun"
  end

  it "slugs are generated with a -# if the slug already exists" do
    s = Show.create(title: "Ruby Rogues")
    e = s.episodes.new(title: "kids are.? fun", description: "abcdefg")
    e.save
    e = s.episodes.new(title: "kids are fun", description: "abcdefg")
    e.save
    e.slug.should == "kids-are-fun-1"
  end

  it "slugs -# is the next consecutive number" do
    s = Show.create(title: "Ruby Rogues")
    e = s.episodes.new(title: "kids are.? fun", description: "abcdefg", slug: "kids-are-fun-5")
    e.save
    e = s.episodes.new(title: "kids are fun", description: "abcdefg")
    e.save
    e.slug.should == "kids-are-fun-6"
  end

  it "slugs are not generated when the slug is already set" do
    s = Show.create(title: "Ruby Rogues")
    e = s.episodes.new(title: "kids are.? fun", description: "abcdefg", slug: "funnykids")
    e.save
    e.slug.should == "funnykids"
  end
end

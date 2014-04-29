require 'spec_helper'

describe Pick do
  context "searching" do
    let!(:rr) { FactoryGirl.create(:show) }
    let!(:hr) { FactoryGirl.create(:show) }

    let!(:chuck) { FactoryGirl.create(:host) }
    let!(:fede) { FactoryGirl.create(:host) }

    let!(:rr_ep1) { FactoryGirl.create(:episode, show: rr) }
    let!(:rr_ep2) { FactoryGirl.create(:episode, show: rr) }
    let!(:hr_ep1) { FactoryGirl.create(:episode, show: hr) }
    let!(:hr_ep2) { FactoryGirl.create(:episode, show: hr) }

    let!(:ruby) { FactoryGirl.create( :pick,
                                     name: "Ruby",
                                     link: "https://www.ruby-lang.org/en/",
                                     episode: rr_ep1,
                                     host: chuck) }

    let!(:tapas) { FactoryGirl.create( :pick,
                                      name: "Ruby Tapas",
                                      link: "http://rubytapas.dpdcart.com",
                                      episode: rr_ep2,
                                      host: chuck) }

    let!(:parley) { FactoryGirl.create( :pick,
                                       name: "RR Parley",
                                       description: "Ruby Rogues Parley mailing list",
                                       link: "http://parley.rubyrogues.com",
                                       episode: hr_ep1,
                                       host: chuck) }

    it "finds all the picks for a certain show" do
      result = Pick.for_show(rr)

      result.count.should == 2
      result.should include ruby, tapas
    end

    it "finds all the picks when the show is not given" do
      result = Pick.for_show(nil)

      result.count.should == 3
      result.should include ruby, tapas, parley
    end

    it "finds all the picks that matches a certain pattern" do
      result = Pick.search("ruby")

      result.count.should == 3
      result.should include ruby, tapas, parley
    end
  end
end

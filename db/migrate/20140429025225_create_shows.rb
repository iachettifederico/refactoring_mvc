class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :title
      t.text :description
      t.string :twitter_link
      t.string :facebook_link
      t.string :google_link
      t.string :rss_link
      t.string :email
      t.string :domain
      t.string :slug
      t.string :host_name
      t.string :itunes_url
    end
  end
end

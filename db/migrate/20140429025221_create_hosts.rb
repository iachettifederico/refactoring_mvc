class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.string :email
      t.string :name
      t.text :bio
      t.string :twitter_handle
      t.string :facebook_handle
      t.string :github_handle
      t.string :slug
      t.string :google_plus_handle
    end
  end
end

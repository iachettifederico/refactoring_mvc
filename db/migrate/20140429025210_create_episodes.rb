class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :title
      t.text :description
      t.string :slug
      t.references :show, index: true
      t.text :show_notes
      t.text :transcript
      t.datetime :published_at
      t.string :duration
    end
  end
end

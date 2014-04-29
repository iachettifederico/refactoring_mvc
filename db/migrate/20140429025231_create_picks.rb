class CreatePicks < ActiveRecord::Migration
  def change
    create_table :picks do |t|
      t.string :name
      t.string :description
      t.string :link
      t.references :host, index: true
      t.references :episode, index: true
    end
  end
end

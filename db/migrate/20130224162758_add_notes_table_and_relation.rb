class AddNotesTableAndRelation < ActiveRecord::Migration
  def up
    remove_column :songs, :music_papers
    add_column :songs, :record, :string

    create_table :notes do |t|
      t.belongs_to :song
      t.string :link
    end
  end

  def down
    drop_table :notes
    add_column :songs, :music_papers, :string
    remove_column :songs, :record
  end
end

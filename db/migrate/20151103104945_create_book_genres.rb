class CreateBookGenres < ActiveRecord::Migration
  def up
    create_table :book_genres do |t|
      t.references :book, :null => false
      t.references :genre, :null => false
    end
  end

  def down
    drop_table :book_genres
  end
end

class CreateBookCopies < ActiveRecord::Migration
  def up
    create_table :book_copies do |t|
      t.string :isbn
      t.references :book, :null => false

      t.boolean :available
      t.references :user

      t.timestamps null: false
    end
  end

  def down
    drop_table :book_copies
  end
end

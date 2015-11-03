class CreateBookCopyUsers < ActiveRecord::Migration

  def up
    create_table :book_copy_users do |t|
      t.references :book_copy, :null => false
      t.references :user, :null => false
      t.date :last_date
      t.timestamps null: false
    end
  end

  def down
    drop_table :book_copy_users
  end

end

class AddColumnToBookCopyUsers < ActiveRecord::Migration
  def up
    add_column :book_copy_users, :return_date, :date
  end

  def down
    remove_column :book_copy_users, :return_date
  end
end

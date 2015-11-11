class AddColumnJobIdToBookCopyUsers < ActiveRecord::Migration
  def up
    add_column :book_copy_users, :job_id, :integer
  end

  def down
    remove_column :book_copy_users, :job_id
  end
end

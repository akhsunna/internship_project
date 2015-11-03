class AddCoverColumnToBook < ActiveRecord::Migration
  def up
    add_attachment :books, :cover
  end

  def down
    remove_attachment :books, :cover
  end
end

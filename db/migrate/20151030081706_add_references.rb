class AddReferences < ActiveRecord::Migration
  def up
    add_reference :books, :author, index: true
    add_foreign_key :books, :authors

    add_reference :books, :language, index: true
    add_foreign_key :books, :languages
  end

  def down
    remove_column :books, :author
    remove_column :books, :language
  end
end

class CreateAuthors < ActiveRecord::Migration
  def up
    create_table :authors do |t|
      t.string :first_name
      t.string :last_name
    end
  end

  def down
    drop_table :authors
  end
end

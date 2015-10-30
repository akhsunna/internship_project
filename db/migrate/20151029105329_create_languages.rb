class CreateLanguages < ActiveRecord::Migration
  def up
    create_table :languages do |t|
      t.string :name
    end
  end

  def down
    drop_table :languages
  end
end

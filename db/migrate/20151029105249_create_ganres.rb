class CreateGanres < ActiveRecord::Migration
  def up
    create_table :ganres do |t|
      t.string :name
    end
  end

  def down
    drop_table :ganres
  end
end

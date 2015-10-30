class CreateBookGanres < ActiveRecord::Migration
  def up
    create_table :book_ganres do |t|
      t.references :book, :null => false
      t.references :ganre, :null => false
    end
  end

  def down
    drop_table :book_ganres
  end
end

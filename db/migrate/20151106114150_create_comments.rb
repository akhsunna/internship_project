class CreateComments < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.text :body
      t.integer :commentable_id
      t.string :commentable_type

      t.references :user, null: false

      t.timestamps null: false
    end

    add_index :comments, [:commentable_id, :commentable_type]
  end

  def down
    drop_table :comments
  end
end

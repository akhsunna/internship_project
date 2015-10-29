class CreateIdentities < ActiveRecord::Migration
  def up
    create_table :identities do |t|
      t.references :user, index: true, foreign_key: true
      t.string :provider
      t.string :uid

      t.timestamps null: false
    end
  end

  def down
    drop_table :identities
  end
end

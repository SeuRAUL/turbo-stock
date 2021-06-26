class CreateStorages < ActiveRecord::Migration[6.0]
  def change
    create_table :storages do |t|
      t.string :name, limit: 20

      t.timestamps
    end
  end
end

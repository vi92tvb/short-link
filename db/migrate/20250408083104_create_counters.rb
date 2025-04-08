class CreateCounters < ActiveRecord::Migration[8.0]
  def change
    create_table :counters do |t|      
      t.string :name, null: false
      t.string :count, default: "0"

      t.timestamps
    end
  end
end

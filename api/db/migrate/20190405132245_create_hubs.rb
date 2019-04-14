class CreateHubs < ActiveRecord::Migration[5.2]
  def change
    create_table :hubs do |t|
      t.string :ch
      t.string :locode
      t.string :name
      t.string :name_wo_diacritics
      t.string :sub_div
      t.string :function
      t.string :status
      t.date :date
      t.string :iata
      t.point :coordinates
      t.string :remarks

      t.timestamps
    end
  end
end

class CreateMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :members do |t|
      t.string :name
      t.string :pws_full_url
      t.string :pws_short_url

      t.timestamps
    end
  end
end

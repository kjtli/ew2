class CreateHeadings < ActiveRecord::Migration[5.1]
  def change
    create_table :headings do |t|
      t.references :member, foreign_key: true
      t.text :content

      t.timestamps
    end
  end
end

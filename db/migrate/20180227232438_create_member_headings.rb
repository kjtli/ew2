class CreateMemberHeadings < ActiveRecord::Migration[5.1]
  def change
    create_table :member_headings do |t|
      t.references :member, foreign_key: true
      t.text :heading

      t.timestamps
    end
  end
end

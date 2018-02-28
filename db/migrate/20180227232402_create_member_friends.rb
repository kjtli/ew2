class CreateMemberFriends < ActiveRecord::Migration[5.1]
  def change
    create_table :member_friends do |t|
      t.references :member, foreign_key: true
      t.integer :friend_id

      t.timestamps
    end
  end
end

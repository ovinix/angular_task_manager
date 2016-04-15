class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true, foreign_key: true
      t.references :task, index: true, foreign_key: true
      t.string :content
      t.string :file

      t.timestamps null: false
    end
  end
end

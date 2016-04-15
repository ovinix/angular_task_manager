class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :user, index: true, foreign_key: true
      t.references :list, index: true, foreign_key: true
      t.string :content
      t.datetime :completed_at

      t.timestamps null: false
    end
  end
end

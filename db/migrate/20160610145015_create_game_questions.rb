class CreateGameQuestions < ActiveRecord::Migration[4.2]
  def change
    create_table :game_questions do |t|
      t.references :game, foreign_key: true
      t.references :question, foreign_key: true, null: false

      # Варианты ответов (распределяются в произвольном порядке при создании)
      t.integer :a
      t.integer :b
      t.integer :c
      t.integer :d

      t.timestamps
    end
  end
end

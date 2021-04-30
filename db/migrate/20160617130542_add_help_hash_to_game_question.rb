class AddHelpHashToGameQuestion < ActiveRecord::Migration[4.2]
  def change
    add_column :game_questions, :help_hash, :text
  end
end

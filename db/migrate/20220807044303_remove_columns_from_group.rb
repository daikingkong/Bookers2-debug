class RemoveColumnsFromGroup < ActiveRecord::Migration[6.1]
  def change
    remove_column :groups, :ouner_id, :integer
  end
end

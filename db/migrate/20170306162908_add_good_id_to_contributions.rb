class AddGoodIdToContributions < ActiveRecord::Migration[5.0]
  def change
    add_column :contributions, :good, :integer, default: 0
  end
end

class AddBadIdToContributions < ActiveRecord::Migration[5.0]
  def change
     add_column :contributions, :bad, :integer, default: 0
  end
end

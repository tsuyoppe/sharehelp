class AddCategoryIdToContributions < ActiveRecord::Migration[5.0]
  def change
     add_column :contributions, :category_id, :integer
  end
end

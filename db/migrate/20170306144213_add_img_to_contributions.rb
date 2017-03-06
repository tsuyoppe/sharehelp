class AddImgToContributions < ActiveRecord::Migration[5.0]
  def change
    add_column :contributions, :img, :string
  end
end

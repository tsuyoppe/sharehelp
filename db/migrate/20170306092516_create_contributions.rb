class CreateContributions < ActiveRecord::Migration[5.0]
  def change
    create_table :contributions do |t|
      t.string :name
      t.string :body
      t.timestamps :false
    end
  end
end

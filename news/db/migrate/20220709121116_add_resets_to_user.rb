class AddResetsToUser < ActiveRecord::Migration[6.1]
  def change
    change_table :users do |t|
      t.string :email
      t.string :reset
    end
  end
end

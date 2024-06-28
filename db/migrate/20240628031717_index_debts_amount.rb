class IndexDebtsAmount < ActiveRecord::Migration[7.1]
  def change
    add_index :debts, :amount, where: "amount > 100000"
  end
end

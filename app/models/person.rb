class Person < ApplicationRecord
  belongs_to :user, optional: true

  has_many :debts, dependent: :destroy
  has_many :payments, dependent: :destroy

  validates :name, :national_id, presence: true
  validates :national_id, uniqueness: true
  validate :cpf_or_cnpj

  before_destroy -> { Redis.cache.del("#{id}-balance") }

  def balance
    # Return cached value if it exists
    balance = Rails.cache.read("#{id}-balance")
    return balance if balance

    # Otherwise, calculate and return the balance
    balance = payments.sum(:amount) - debts.sum(:amount)
    Rails.cache.write("#{id}-balance", balance, expires_in: 1.day)
    balance
  end

  def add_value_to_balance(value)
    Rails.cache.delete("#{id}-balance")
    new_balance = balance + value
    Rails.cache.write("#{id}-balance", new_balance, expires_in: 1.day)
  end

  def remove_value_from_balance(value)
    Rails.cache.delete("#{id}-balance")
    new_balance = balance - value
    Rails.cache.write("#{id}-balance", new_balance, expires_in: 1.day)
  end

  private

  def cpf_or_cnpj
    if !CPF.valid?(national_id) && !CNPJ.valid?(national_id)
      errors.add :national_id, :invalid
    end
  end
end

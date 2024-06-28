class Person < ApplicationRecord
  audited

  belongs_to :user, optional: true

  has_many :debts, dependent: :destroy
  has_many :payments, dependent: :destroy

  validates :name, :national_id, presence: true
  validates :national_id, uniqueness: true
  validate :cpf_or_cnpj

  before_destroy -> { Rails.cache.delete("#{id}-balance") }

  def balance
    Rails.cache.fetch("#{id}-balance", expires_in: 1.day) do
      payments.sum(:amount) - debts.sum(:amount)
    end
  end

  def update_balance(value)
    Rails.cache.delete("#{id}-balance")
    new_balance = balance + value
    Rails.cache.write("#{id}-balance", new_balance, expires_in: 1.day)
  end

  private

  def cpf_or_cnpj
    if !CPF.valid?(national_id) && !CNPJ.valid?(national_id)
      errors.add :national_id, :invalid
    end
  end
end

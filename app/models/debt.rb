class Debt < ApplicationRecord
  belongs_to :person

  validates :amount, presence: true

  after_save -> { person.update_balance(-amount) }
  before_destroy -> { person.update_balance(amount) }
end

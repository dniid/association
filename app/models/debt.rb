class Debt < ApplicationRecord
  belongs_to :person

  validates :amount, presence: true

  after_save -> { person.remove_value_from_balance(amount) }
  before_destroy -> { person.add_value_to_balance(amount) }
end

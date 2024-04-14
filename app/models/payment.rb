class Payment < ApplicationRecord
  belongs_to :person

  after_save -> { person.add_value_to_balance(amount) }
  before_destroy -> { person.remove_value_from_balance(amount) }
end

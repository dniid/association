class Payment < ApplicationRecord
  belongs_to :person

  after_save -> { person.update_balance(amount) }
  before_destroy -> { person.update_balance(-amount) }
end

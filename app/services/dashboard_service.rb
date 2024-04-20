class DashboardService
  attr_reader :current_user

  def initialize(current_user)
    @current_user = current_user
  end

  def people_by_activity
    Rails.cache.fetch("dash-people-activity", expires_in: 12.hours) do
      counts = Person.group(:active).count
      {
        active: counts[true] || 0,
        inactive: counts[true] || 0,
      }
    end
  end

  def total_debts
    Rails.cache.fetch("dash-total-debts", expires_in: 12.hours) do
      Debt.joins(:person).where(people: { active: true }).sum(:amount)
    end
  end

  def total_payments
    Rails.cache.fetch("dash-total-payments", expires_in: 12.hours) do
      Payment.joins(:person).where(people: { active: true }).sum(:amount)
    end
  end

  def total_balance
    # Would it make sense to cache this?
    total_payments - total_debts
  end

  def last_debts
    Rails.cache.fetch("dash-last-debts", expires_in: 12.hours) do
      Debt.order(created_at: :desc).limit(10).map do |debt|
        [debt.id, debt.amount]
      end
    end
  end

  def last_payments
    Rails.cache.fetch("dash-last-payments", expires_in: 12.hours) do
      Payment.order(created_at: :desc).limit(10).map do |payment|
        [payment.id, payment.amount]
      end
    end
  end

  def recent_people_by_user
    Rails.cache.fetch("dash-#{current_user.id}-recent-people", expires_in: 12.hours) do
      Person.where(user: current_user).order(:created_at).limit(10)
    end
  end

  def top_person
    Rails.cache.fetch("dash-top-person", expires_in: 12.hours) do
      Person
        .select("people.*, (COALESCE(SUM(payments.amount), 0) - COALESCE(SUM(debts.amount), 0)) AS balance")
        .left_joins(:payments, :debts)
        .where("people.active = true")
        .group("people.id")
        .having("balance > 0")
        .order("balance")
        .last
    end
  end

  def bottom_person
    Rails.cache.fetch("dash-bottom-person", expires_in: 12.hours) do
      Person
        .select("people.*, (COALESCE(SUM(payments.amount), 0) - COALESCE(SUM(debts.amount), 0)) AS balance")
        .left_joins(:payments, :debts)
        .where("people.active = true")
        .group("people.id")
        .having("balance > 0")
        .order("balance")
        .first
    end
  end
end

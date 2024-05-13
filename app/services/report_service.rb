require 'csv'

class ReportService
  attr_reader :current_user

  def initialize(current_user)
    # Might wanna use this in the future for filtering and stuff
    @current_user = current_user
  end

  def generate_csv
    attributes = %w{name balance}
    people = Person.order(:name).all

    CSV.generate(headers: true) do |csv|
      csv << attributes

      people.each do |person|
        csv << attributes.map{ |attr| person.send(attr) }
      end
    end
  end

end

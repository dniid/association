class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    @dashboard_service = DashboardService.new(current_user)
  end
end

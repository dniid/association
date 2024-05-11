class PersonMailer < ApplicationMailer

  def balance_report(user)
    @user = user
    @report_service = ReportService.new(current_user)

    mail(to: @user.email, subject: 'Relatório de saldos')
  end
end

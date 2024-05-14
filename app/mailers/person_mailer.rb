class PersonMailer < ApplicationMailer

  def balance_report(user_id)
    @user = User.find(user_id)

    report_service = ReportService.new(@user)
    attachments['saldos.csv'] = {
      :mime_type => 'text/csv',
      :content => report_service.generate_csv
    }
    mail(to: @user.email, subject: 'Relatório de saldos')
  end
end

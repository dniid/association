class PersonMailer < ApplicationMailer

  def balance_report(user)
    @user = user
    mail(to: @user.email, subject: 'Relatório de saldos')
  end
end

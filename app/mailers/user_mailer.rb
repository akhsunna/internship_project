class UserMailer < ApplicationMailer
  default from: '1111@gmail.com'

  def reminder_email(user, book)
    @user = user
    @book = book
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'You are DEBTOR!')
  end
end

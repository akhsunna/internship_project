# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def reminder_mail_preview
    ExampleMailer.reminder_email(User.first)
  end
end

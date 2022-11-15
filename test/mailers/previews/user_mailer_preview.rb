# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/confirmation
  def confirmation
    user = User.first
    UserMailer.confirmation(user, user.generate_confirmation_token)
  end

end

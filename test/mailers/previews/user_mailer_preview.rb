# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/project_expired_notice
  def project_expired_notice
    UserMailer.project_expired_notice
  end

end

class NewUserMailer < ApplicationMailer

  def user_password_reset(user)
    @user = user
    @raw_token, enc_token = Devise.token_generator.generate(User, :reset_password_token)
    @user.update({
      reset_password_token: enc_token,
      reset_password_sent_at: Time.now
    })
    mail(
      to: @user.email,
      subject: 'Welcome! Please set your password'
    )
  end
end

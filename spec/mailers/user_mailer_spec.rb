require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "#password_reset" do
    let(:user) {create :user, reset_token: "anything"}
    let(:mail) {UserMailer.password_reset user}

    it "send user password reset url" do
      expect(mail.subject).to eq "Password Reset"
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq [ENV['email_from']]
      expect(mail.body.encoded).to match(
        edit_user_password_reset_path user, user.reset_token)
    end
  end
end

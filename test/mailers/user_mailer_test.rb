require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  setup do
    @user = users(:one)
  end

  test "confirmation" do
    mail = UserMailer.confirmation(@user, @user.generate_confirmation_token)
    assert_equal "Confirmation Instructions", mail.subject
    assert_equal [@user.email], mail.to
    assert_equal [CONFIG[:send_email_from]], mail.from
    assert_match "Click here to confirm your email", mail.body.encoded 
  end

end

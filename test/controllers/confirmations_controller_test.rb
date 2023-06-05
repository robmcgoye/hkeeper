require "test_helper"

class ConfirmationsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = User.create( first_name: "billy", last_name: "joe", email: "billyjoe@example.com", 
      password: "password", active: true )
  end

  test "should confirm user account email" do
    post login_path, params: { user: { email: @user.email, password: @user.password } }
    assert_redirected_to new_confirmation_url
    post confirmations_url, params: { user: { email: @user.email }}
    assert_redirected_to root_url
    assert_equal "Check your email for confirmation instructions.", flash[:notice]
    get edit_confirmation_url( @user.generate_confirmation_token )
    assert_redirected_to root_url
    assert_equal "Your account has been confirmed.", flash[:notice]
  end

end

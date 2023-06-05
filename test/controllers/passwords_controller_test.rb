require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = User.create(first_name: "billy", last_name: "joe", email: "billyjoe@example.com", 
      password: "password", active: true, confirmed_at: Date.today)
  end

  test "should update password for user" do
    get new_password_url
    assert_response :success
    post passwords_url,  params: { user: { email: @user.email }}
    assert_redirected_to root_url
    assert_equal "If that user exists we've sent instructions to their email.", flash[:notice] 
    token = @user.generate_password_reset_token
    get edit_password_url( token )
    assert_response :success
    patch password_url(token), params: { user: {password: "drowssap", password_confirmation: "drowssap"} }
    assert_redirected_to login_url
    assert_equal "Sign in.", flash[:notice]
  end

end

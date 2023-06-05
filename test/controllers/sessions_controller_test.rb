require "test_helper"

# Need to test failed logins

class SessionsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = User.create(first_name: "billy", last_name: "joe", email: "billyjoe@example.com", 
      password: "password", active: true, confirmed_at: Date.today)
  end

  test "should get login" do
    get login_url
    assert_response :success
  end

  test "should login" do
    post login_url, params: { user: { email: "billyjoe@example.com", password: "password" }}
    assert_redirected_to root_url
  end

  test "should logout" do
    sign_in_as(@user)
    delete logout_url
    assert_redirected_to root_url
  end

end

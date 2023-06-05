require "test_helper"

# Need to test permissions/auth

class ApiKeysControllerTest < ActionDispatch::IntegrationTest

  setup do
    @admin_user = create_admin_user
    @user = create_user
    @account = Account.create(name: "abc", active: true)
  end

  test "should generate new api key for account" do
    sign_in_as(@admin_user)
    post account_api_keys_url(@account)
    assert_redirected_to edit_account_url(@account)
  end

end

require "test_helper"

# need to add tests for checking permissions/auth

class AccountRolesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @admin_user = create_admin_user
    @user = create_user
    @account = Account.create(name: "abc", active: true)
  end

  test "should get index" do
    sign_in_as(@admin_user)
    get account_roles_url(@account)
    assert_response :success
  end

  test "should get new" do
    sign_in_as(@admin_user)
    get account_roles_new_url(@account)
    assert_response :success
  end

  test "should add role to account for user" do
    sign_in_as(@admin_user)
    post account_roles_new_url(@account), params: { user_id: @user.id }
    assert_redirected_to account_roles_url(@account)
    assert_equal "User was successfully added.", flash[:notice]
  end

  test "should remove role from account for user" do
    sign_in_as(@admin_user)
    delete account_role_removal_url(@account, @user)
    assert_redirected_to account_roles_url(@account)
  end

end

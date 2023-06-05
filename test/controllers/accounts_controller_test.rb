require "test_helper"
# Need to add checks for permissions etc.

class AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = create_admin_user
    @user = create_user
    @account = Account.create(name: "abc", active: true)
  end

  test "should get index" do
    sign_in_as(@admin_user)
    get accounts_url
    assert_response :success
  end

  test "should get new" do
    sign_in_as(@admin_user)
    get new_account_url
    assert_response :success
  end

  test "should create account" do
    sign_in_as(@admin_user)
    assert_difference("Account.count") do
      post accounts_url, params: { account: { name: "xyz", active: true } }
    end
    assert_redirected_to accounts_url
  end

  test "should show account" do
    sign_in_as(@admin_user)
    get account_url(@account)
    assert_response :success
  end

  test "should get edit" do
    sign_in_as(@admin_user)
    get edit_account_url(@account)
    assert_response :success
  end

  test "should update account" do
    sign_in_as(@admin_user)
    patch account_url(@account), params: { account: { name: "new", active: false } }
    assert_redirected_to accounts_url
  end

  test "should destroy account" do 
    sign_in_as(@admin_user)
    assert_difference('Account.count', -1) do
      delete account_url(@account)
    end
    assert_redirected_to accounts_url
    assert_equal "Account was successfully destroyed.", flash[:notice]
  end
end

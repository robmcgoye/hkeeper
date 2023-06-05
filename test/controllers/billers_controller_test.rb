require "test_helper"

# Need to test permissions/auth

class BillersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @admin_user = create_admin_user
    @user = create_user
    @account = Account.create(name: "abc", active: true)
  end

  test "should get edit" do
    @biller = create_biller(@account)
    sign_in_as(@admin_user)
    get edit_account_biller_url(@account, @biller)
    assert_response :success
  end

  test "should get new" do
    sign_in_as(@admin_user)
    get new_account_biller_url(@account)
    assert_response :success
  end

  test "should create biller" do
    sign_in_as(@admin_user)
    assert_difference('Biller.count') do
      post account_billers_path(@account), params: { biller: { address_line_1: "9560 frangipani rd", city: "VB", state: "FL", zip: "32963", name: "The Name" } }
    end
    assert_redirected_to accounts_path
  end

  test "should update biller" do
    @biller = create_biller(@account)
    sign_in_as(@admin_user)
    patch account_biller_path(@account, @biller), params: { biller: { address_line_2: "jim_bob" } }
    assert_redirected_to accounts_path
  end

end

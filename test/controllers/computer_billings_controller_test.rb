require "test_helper"

class ComputerBillingsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @admin_user = create_admin_user
    @user = create_user
    @account = Account.create(name: "abc", active: true)
  end

  test "should get edit" do
    @biller = create_computer_billing(@account)
    sign_in_as(@admin_user)
    get edit_account_computer_billing_url(@account, @biller)
    assert_response :success
  end

  test "should get new" do
    sign_in_as(@admin_user)
    get new_account_computer_billing_url(@account)
    assert_response :success
  end

  test "should create computer billing" do
    sign_in_as(@admin_user)
    assert_difference('ComputerBilling.count') do
      post account_computer_billings_url(@account), params: { computer_billing: { cost_per_computer: "10" } }
    end
    assert_redirected_to accounts_path
  end

  test "should update computer billing" do
    @biller = create_computer_billing(@account)
    sign_in_as(@admin_user)
    patch account_computer_billing_url(@account, @biller), params: { computer_billing: { cost_per_computer: "12" } }
    assert_redirected_to accounts_path
  end

end

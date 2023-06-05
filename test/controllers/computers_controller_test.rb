require "test_helper"

class ComputersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @admin_user = create_admin_user
    @user = create_user
    @account = Account.create(name: "abc", active: true)
    @computer = Computer.create(name: "one", key: "11111", account_id: @account.id)
  end

  test "should get index" do
    sign_in_as(@admin_user)
    get computers_url
    assert_response :success
  end

  test "should show computer" do
    sign_in_as(@admin_user)
    get computer_url(@computer)
    assert_response :success
  end

  test "should edit computer" do
    sign_in_as(@admin_user)
    get edit_computer_url(@computer)
    assert_response :success
  end

  test "should update computer" do
    sign_in_as(@admin_user)
    patch computer_url(@computer), params: {  computer: {  notes: "asd" } } 
    assert_redirected_to computer_url(@computer)
  end

  test "should delete computer" do
    computer = Computer.create(name: "two", key: "22222", account_id: @account.id)
    sign_in_as(@admin_user)
    assert_difference('Computer.count', -1) do
      delete computer_url(computer)
    end
    assert_redirected_to computers_url    
  end

end

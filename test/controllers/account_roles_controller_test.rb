require "test_helper"

class AccountRolesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get account_roles_edit_url
    assert_response :success
  end
end

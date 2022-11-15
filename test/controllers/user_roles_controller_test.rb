require "test_helper"

class UserRolesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_roles_index_url
    assert_response :success
  end
end

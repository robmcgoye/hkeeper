require "test_helper"

# Need to add checks for permissions / authentications

class UserRolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = create_admin_user
    @user = create_user
  end

  test "should edit user_roles" do
    sign_in_as(@admin_user)
    get user_administration_roles_path(@user)
    assert_response :success    
  end

  test "should update user_roles" do
    sign_in_as(@admin_user)
    post user_administration_roles_path(@user), params: { user_role: { admin: "0", tech: "1", user: "1" } }
    assert_redirected_to user_administration_index_path
    assert_equal "Updated roles for #{@user.full_name}.", flash[:notice]
  end

end

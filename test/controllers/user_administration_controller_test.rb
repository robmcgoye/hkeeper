require "test_helper"
# Need to add checks for permissions on create,update

class UserAdministrationControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = create_admin_user
    @user = create_user
  end

  test "should get index" do
    sign_in_as(@admin_user)
    get user_administration_index_path
    assert_response :success
  end

  test "should get not authorized for index" do
    sign_in_as(@user)
    get user_administration_index_path
    assert_redirected_to root_path
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end  
  
  test "should get not authorized for show" do
    sign_in_as(@user)
    get user_administration_url(@admin_user)
    assert_redirected_to root_path
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end

  test "should show user" do
    sign_in_as(@admin_user)
    get user_administration_url(@user)
    assert_response :success
  end

  test "should get new" do
    sign_in_as(@admin_user)
    get new_user_administration_url
    assert_response :success
  end

  test "should get edit" do
    sign_in_as(@admin_user)
    get edit_user_administration_url(@user)
    assert_response :success
  end

  test "should create user" do
    sign_in_as(@admin_user)
    assert_difference('User.count') do
      post user_administration_index_url, params: { user: { first_name: "test", email: "test@test.com", password: "password" } }
    end
    assert_redirected_to user_administration_url(User.last)
  end

  test "should update user" do
    sign_in_as(@admin_user)
    patch user_administration_url(@user), params: { user: { last_name: "jim_bob" } }
    assert_redirected_to user_administration_url(@user)
  end

end

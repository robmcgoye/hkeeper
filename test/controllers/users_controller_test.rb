require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create_user
  end
  
  test "should get new" do
    get sign_up_url
    assert_response :success
  end

  test "should get edit" do
    sign_in_as(@user)
    get profile_url(@user)
    assert_response :success
  end

  test "should update current user" do
    sign_in_as(@user)
    put profile_url(@user), params: { user: { last_name: "jim_bob", first_name: "test", email: "test@test.com", current_password: "password" } }
    assert_redirected_to root_path
  end

  test "should delete current user" do
    sign_in_as(@user)
    assert_difference('User.count', -1) do
      delete profile_url(@user)
    end
    assert_redirected_to root_path
  end

  test "should create new user" do
    assert_difference('User.count') do
      post sign_up_url, params: { user: { first_name: "test", email: "test@test.com", password: "password", password_confirmation: "password" } }
    end
    assert_redirected_to root_path
  end

  test "should redirect authenticated user on create" do
    sign_in_as(@user)
    post sign_up_url, params: { user: { first_name: "test", email: "test@test.com", password: "password", password_confirmation: "password" } }
    assert_redirected_to root_path
    assert_equal "You are already logged in.", flash[:alert]
  end

  test "should redirect authenticated user on new" do
    sign_in_as(@user)
    get sign_up_url
    assert_redirected_to root_path  
    assert_equal "You are already logged in.", flash[:alert]
  end
  
  test "should prompt to login user on edit" do
    get profile_url(@user)
    assert_redirected_to login_path  
    assert_equal "You need to login to access that page.", flash[:alert]
  end
  
  test "should prompt to login user on update" do
    put profile_url(@user), params: { user: { last_name: "jim_bob" } }
    assert_redirected_to login_path  
    assert_equal "You need to login to access that page.", flash[:alert]
  end

  test "should prompt to login user on destroy" do
    delete profile_url(@user)
    assert_redirected_to login_path  
    assert_equal "You need to login to access that page.", flash[:alert]
  end
  
end

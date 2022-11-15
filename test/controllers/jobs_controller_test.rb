require "test_helper"

class JobsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get jobs_new_url
    assert_response :success
  end
end

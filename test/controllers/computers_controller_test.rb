require "test_helper"

class ComputersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get copmuters_index_url
    assert_response :success
  end
end

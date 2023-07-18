require "test_helper"

class StatementsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @admin_user = create_admin_user
    @user = create_user
    account = Account.create(name: "abc", active: true)
    biller = create_biller(account)
    unifi_site = UnifiSite.create(account_id: account.id, name: "uni site", hosting_fee: "99")
    @statement = Statement.create
    Invoice.create(service_id: unifi_site.id, service_type: "UnifiSite", statement_id: @statement.id)
  end

  test "should get index" do
    sign_in_as(@admin_user)
    get statements_url
    assert_response :success
  end
  
  # test "should get pdf" do
  #   sign_in_as(@admin_user)
  #   get pdf_statement_url(@statement)
  #   assert_equal 'application/pdf', request.content_type
  # end

  test "should get edit" do
    sign_in_as(@admin_user)
    get edit_statement_url(@statement)
    assert_response :success
  end

  test "should show statement" do
    sign_in_as(@admin_user)
    get statement_url(@statement)
    assert_response :success
  end

  test "should update statement" do
    sign_in_as(@admin_user)
    patch statement_url(@statement), params: {  statement: {  status: "paid" } } 
    assert_redirected_to statement_url(@statement)
  end

end

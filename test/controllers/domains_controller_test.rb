require "test_helper"

# Need to test permissions/auth and filter

class DomainsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin_user = create_admin_user
    @user = create_user
    @account = Account.create(name: "abc", active: true)
    @domain = Domain.create(account_id: @account.id, name: "domain.com", 
      expires_on: Date.today + 1.year, hosting_fee: "99", web_hosting: "1",
      email_hosting: "0", registration: "1", registration_fee: "20")
  end

  test "should get index" do
    sign_in_as(@admin_user)
    get domains_url
    assert_response :success
  end

  test "should get new" do
    sign_in_as(@admin_user)
    get new_domain_url
    assert_response :success
  end

  test "should create domain" do
    sign_in_as(@admin_user)
    assert_difference("Domain.count") do
      post domains_url, params: { domain: { account_id: @account.id, name: "domain2.com", 
        expires_on: Date.today + 1.year, hosting_fee: "99", web_hosting: "1",
        email_hosting: "0", registration: "1", registration_fee: "20" } }
    end
    assert_redirected_to domain_url(Domain.last)
  end

  test "should show domain" do
    sign_in_as(@admin_user)
    get domain_url(@domain)
    assert_response :success
  end

  test "should get edit" do
    sign_in_as(@admin_user)
    get edit_domain_url(@domain)
    assert_response :success
  end

  test "should update domain" do
    sign_in_as(@admin_user)
    patch domain_url(@domain), params: { domain: { email_hosting: "1" } }
    assert_redirected_to domain_url(@domain)
  end

  test "should destroy domain" do
    sign_in_as(@admin_user)
    assert_difference("Domain.count", -1) do
      delete domain_url(@domain)
    end
    assert_redirected_to domains_url
  end

end

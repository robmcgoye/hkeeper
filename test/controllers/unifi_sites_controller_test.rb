require "test_helper"
# Need to test permissions/auth and filter

class UnifiSitesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @admin_user = create_admin_user
    @user = create_user
    @account = Account.create(name: "abc", active: true)
    @unifi_site = UnifiSite.create(account_id: @account.id, name: "uni site", hosting_fee: "99")
  end

  test "should get index" do
    sign_in_as(@admin_user)
    get unifi_sites_url
    assert_response :success
  end

  test "should get new" do
    sign_in_as(@admin_user)
    get new_unifi_site_url
    assert_response :success
  end

  test "should get edit" do
    sign_in_as(@admin_user)
    get edit_unifi_site_url(@unifi_site)
    assert_response :success
  end

  test "should show unifi site" do
    sign_in_as(@admin_user)
    get unifi_site_url(@unifi_site)
    assert_response :success
  end

  test "should create unifi site" do
    sign_in_as(@admin_user)
    assert_difference('UnifiSite.count') do
      post unifi_sites_url, params: { unifi_site: { account_id: @account.id, name: "test", hosting_fee: "89" } }
    end
    assert_redirected_to unifi_site_url(UnifiSite.last)
  end

  test "should update unifi site" do
    sign_in_as(@admin_user)
    patch unifi_site_url(@unifi_site), params: {  unifi_site: {  hosting_fee: "89" } } 
    assert_redirected_to unifi_site_url(@unifi_site)
  end

  test "should delete unifi site" do
    sign_in_as(@admin_user)
    assert_difference('UnifiSite.count', -1) do
      delete unifi_site_url(@unifi_site)
    end
    assert_redirected_to unifi_site_url
  end
end

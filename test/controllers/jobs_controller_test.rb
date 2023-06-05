require "test_helper"

class JobsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @admin_user = create_admin_user
    @user = create_user
    @account = Account.create(name: "abc", active: true)
    @computer = Computer.create(name: "one", key: "11111", account_id: @account.id)
    @job = Job.create(computer_id: @computer.id, action: "check_disk", execute_after: Date.today, days_to_recur: "15", status: "run_once")
  end
  
  test "should get new" do
    sign_in_as(@admin_user)
    get new_computer_job_url(@computer)
    assert_response :success
  end

  test "should show computer job" do
    sign_in_as(@admin_user)
    get job_url(@job)
    assert_response :success
  end

  test "should edit computer job" do
    sign_in_as(@admin_user)
    get edit_job_url(@job)
    assert_response :success
  end

  test "should update computer job" do
    sign_in_as(@admin_user)
    patch job_url(@job), params: { job: {  status: "recurring" } } 
    assert_redirected_to computer_url(@computer)
    assert_equal "The Job was successfully updated", flash[:notice]
  end

  test "should create computer job" do
    sign_in_as(@admin_user)
    assert_difference('@computer.jobs.count') do
      post computer_jobs_url(@computer), params: { job: { action: "rebuild_indexes", execute_after: Date.today, days_to_recur: "15", status: "run_once" } }
    end
    assert_redirected_to computer_url(@computer)
    assert_equal "The Job was successfully created", flash[:notice]
  end

  test "should delete computer job" do
    job = Job.create(computer_id: @computer.id, action: "install_updates", execute_after: Date.today, days_to_recur: "15", status: "run_once")
    sign_in_as(@admin_user)
    assert_difference('@computer.jobs.count', -1) do
      delete job_url(job)
    end
    assert_redirected_to computer_url(@computer)
    assert_equal "The Job was successfully deleted", flash[:notice]
  end

end

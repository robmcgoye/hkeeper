ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def sign_in_as(user)
    post login_path, params: { user: { email: user.email, password: user.password } }
  end

  def create_biller(account)
    Biller.create(account_id: account.id, address_line_1: "9560 frangipani rd", city: "VB", state: "FL", zip: "32963", name: "The Name")
  end
  
  def create_computer_billing(account)
    ComputerBilling.create(account_id: account.id, cost_per_computer: "15")
  end

  def create_admin_user
    admin_user = User.create(first_name: "john", last_name: "Doe", email: "johndoe@example.com", 
      password: "password", active: true, confirmed_at: Date.today)
    admin_user.add_role :admin
    return admin_user
  end

  def create_user
    User.create(first_name: "billy", last_name: "joe", email: "billyjoe@example.com", 
      password: "password", active: true, confirmed_at: Date.today)
  end

end

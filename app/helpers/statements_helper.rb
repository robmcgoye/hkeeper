module StatementsHelper

  def account_options(options = {})
    options_for_select([["All",0]] + policy_scope(Account).map{|a| [a.name, a.id]}, options)
  end

end
# @accounts = [["All",0]]
# @accounts += policy_scope(Account).map{|a| [a.name, a.id]}
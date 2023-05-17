class Computer < ApplicationRecord
  belongs_to :account
  has_many :jobs, dependent: :destroy
  validates :key, presence: true
  validates_uniqueness_of :key, scope: :account_id

  scope :computers_in_account, -> (account_ids) { where(account_id: account_ids) }
  scope :not_contacted, -> (number_of_days = 15) { where("last_contacted_at isnull or last_contacted_at < ?", (Date.today - number_of_days.days)) }

end
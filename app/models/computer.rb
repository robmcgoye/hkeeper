class Computer < ApplicationRecord
  belongs_to :account
  has_many :jobs, dependent: :destroy
  validates :key, presence: true
  validates_uniqueness_of :key, scope: :account_id

  scope :computers_in_account, -> (account_ids) { where(account_id: account_ids) }
  scope :not_contacted, -> { where("last_contacted_at isnull or last_contacted_at < ?", (Date.today - 15.days)) }

end
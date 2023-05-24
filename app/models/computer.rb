class Computer < ApplicationRecord
  belongs_to :account
  has_many :jobs, dependent: :destroy
  validates :key, presence: true
  validates_uniqueness_of :key, scope: :account_id

  scope :computers_in_account, -> (account_ids) { where(account_id: account_ids) }
  scope :not_contacted, -> (number_of_days = 15) { where("last_contacted_at isnull or last_contacted_at < ?", (Date.today - number_of_days.days)) }

  # scope :job_errors, -> { distinct.joins(jobs: [:job_events]).where("job_events.status" => 2) }
  scope :job_errors, -> { distinct.joins(jobs: [:job_events]).where("job_events.status" => 2) }
  scope :last_contacted, -> (number_of_days) { where("last_contacted_at > ?", (Date.today - number_of_days)) }
  scope :recent_job_errors, -> (number_of_days) { last_contacted(number_of_days).job_errors }

  scope :bios_aged, -> (number_of_years) { where("bios_released_on < ?", (Date.today - number_of_years.years)) }
  # Computer.where("bios_released_on < ?", (Date.today - 3.years))

end
class Job < ApplicationRecord
  belongs_to :computer
  has_many :job_events, dependent: :destroy

  validates :action, presence: true, 
                      length: { minimum: 2, maximum: 25 }, 
                      uniqueness: { scope: :computer_id }

  validates :execute_after, comparison: { greater_than_or_equal_to: Date.today }, on: :create 
  validates :days_to_recur, numericality: { only_integer: true }
  
  enum :status, { run_once: 0, recurring: 1, archived: 2 }, default: :run_once
  
  scope :que, ->(today) { where("status <> 2 AND execute_after < ?", today) }


end
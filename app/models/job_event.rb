class JobEvent < ApplicationRecord
  belongs_to :job

  enum :status, { je_info: 0, je_warning: 1, je_error: 2 }, default: :je_info
  
  after_save :send_alert, unless: Proc.new { status != "je_error" }

  scope :errors, -> { where(status: :je_error).order(updated_at: :desc) }
  
  def get_status
    if status == "je_info"
      "Info"
    elsif status == "je_warning"
      "Warning"
    elsif status == "je_error"
      "Error"
    else
      "unknown"
    end
  end

  private

  def send_alert
    UserMailer.job_alert(id).deliver_later
  end

end
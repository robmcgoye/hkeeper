class EventAlertJob < ApplicationJob
  queue_as :default

  def perform(job_event_id)
    # Do something later
    # UserMailer.job_error(job_event_id).deliver_later
    # puts "Hello world!! #{job_event_id}"
  end

end

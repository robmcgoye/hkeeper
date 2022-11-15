class EventAlertJob < ApplicationJob
  queue_as :default

  def perform(job_event_id)
    # Do something later
    puts "Hello world!! #{job_event_id}"
  end

end

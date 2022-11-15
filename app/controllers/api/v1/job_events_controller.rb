class Api::V1::JobEventsController < Api::V1::BaseController
  before_action :set_job, only: [:create] 
  before_action :authorize_job, only: [:create]

  def create
    @event = @job.job_events.build(event_params)
    if @event.save
      render json: { message: "ok" }, status: :ok
    else
      render json: { message: @event.errors }, status: :unprocessable_entity
    end
  end

  private

    def set_job
      @job = Job.find(params[:job_id])
    end

    def event_params
      params.require(:job_event).permit(:notes, :status)
    end

    def authorize_job
      render json: { message: "Unauthorized" }, status: :unauthorized unless @account == @job.computer.account
    end  
  
end
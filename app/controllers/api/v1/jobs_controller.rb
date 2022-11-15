class Api::V1::JobsController < Api::V1::BaseController
  before_action :set_computer, only: [:index] 
  before_action :set_job, only: [:completed] 
  before_action :authorize_computer, only: [:index, :completed]

  def index
    @jobs = @computer.jobs.que(Date.today + 1)
  end

  def completed
    @job.execute_after = @job.execute_after + @job.days_to_recur.days
    if @job.status == "run_once"
      @job.status = "archived"
    end
    if @job.save
      render json: { message: "ok" }, status: :ok
    else
      render json: { message: @job.errors }, status: :unprocessable_entity
    end
  end

  private

    def set_job
      @job = Job.find(params[:id])
      @computer = @job.computer
    end

    def set_computer
      @computer = Computer.find(params[:computer_id])
    end

    def authorize_computer
      render json: { message: "Unauthorized" }, status: :unauthorized unless @account == @computer.account
    end  

end
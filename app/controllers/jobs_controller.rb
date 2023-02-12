class JobsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_computer, only: [ :new, :create ]
  before_action :set_job, except: [ :new, :create ]
  
  def new
    @job = @computer.jobs.new
    authorize @job
  end

  def show
    @pagy, @events = pagy(@job.job_events)
  end
  
  def edit
  end

  def create
    @job = @computer.jobs.build( job_params )
    authorize @job
    if @job.save
      flash[:notice] = "The Job was successfully created"
      redirect_to computer_path(@computer)
    else
      render :new
    end
  end

  def update
    if @job.update( job_params )
      flash[:notice] = "The job was successfully updated"
      redirect_to computer_path(@computer)
    else
      render :edit
    end
  end

  def destroy
    @job.destroy
    flash[:notice] = "The job was successfully deleted"
    redirect_to computer_path(@computer)
  end 
  
  private
  
    def set_computer
      @computer = Computer.find(params[:computer_id])
    end

    def set_job
      @job = Job.find(params[:id])
      @computer = @job.computer
      authorize @job
    end

    def job_params
      params.require(:job).permit(:action, :execute_after, :notes, :days_to_recur, :status)
    end

end

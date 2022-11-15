class ComputersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_computer, only: [ :show, :destroy ]
  
  def index
    @computers = policy_scope(Computer)
  end

  def show
    @pagy, @jobs = pagy(@computer.jobs)
    # @pagy, @jobs = pagy(@computer.jobs, page: 2)
  end

  def destroy  
    @computer.destroy
    flash[:notice] = "The computer was successfully deleted"
    redirect_to computers_path
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_computer
    @computer = Computer.find(params[:id])
    authorize @computer
  end

end

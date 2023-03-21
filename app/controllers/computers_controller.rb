class ComputersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_computer, only: [ :edit, :update, :show, :destroy ]
  
  def filter
    @computer_form = ComputerFilterForm.new(computer_filter_params)
    @pagy, @computers = pagy(policy_scope(Computer))

    if params[:computer_filter_form][:account_id].to_i > 0
      @pagy, @computers = pagy(policy_scope(Computer).computers_in_account(params[:computer_filter_form][:account_id].to_i))
    else
      @pagy, @computers = pagy(policy_scope(Computer))
    end    
  end 
  
  def index
    @computer_form = ComputerFilterForm.new
    @pagy, @computers = pagy(policy_scope(Computer))
  end

  def show
    @pagy, @jobs = pagy(@computer.jobs)
    # @pagy, @jobs = pagy(@computer.jobs, page: 2)
  end

  def edit
  end

  def update
    if @computer.update(computer_params)
      redirect_to computer_url(@computer), notice: "The notes were successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
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

  def computer_params
    params.require(:computer).permit(:notes)
  end

  def computer_filter_params
    params.require(:computer_filter_form).permit(:account_id)
  end
end

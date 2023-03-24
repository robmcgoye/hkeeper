class ComputersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_computer, only: [ :edit, :update, :show, :destroy ]
  
  def filter
    set_filter(:computer_filter, {"account_id" => params[:computer_filter_form][:account_id]})
    @computer_form = ComputerFilterForm.new(computer_filter_params)
    @pagy, @computers = pagy(@computer_form.filter(policy_scope(Computer)))  
  end 
  
  def index
    computer_filter = get_filter(:computer_filter)
    if computer_filter.nil?
      @computer_form = ComputerFilterForm.new
    else
      @computer_form = ComputerFilterForm.new(computer_filter)
    end
    @pagy, @computers = pagy(@computer_form.filter(policy_scope(Computer)))
  end

  def show
    @pagy, @jobs = pagy(@computer.jobs)
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
    params.require(:computer).permit(:notes, :description)
  end

  def computer_filter_params
    params.require(:computer_filter_form).permit(:account_id)
  end
end

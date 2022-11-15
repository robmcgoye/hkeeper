class Api::V1::ComputersController < Api::V1::BaseController
  before_action :set_computer, only: [:show, :update] 
  before_action :authorize_computer, only: [:show, :update]

  def show_by_key
    @computer = Computer.find_by key: params[:key]
    authorize_computer
  end

  def show
  end

  def create
    @computer = @account.computers.build(computer_params)
    if @computer.save
      render :show, status: :created
    else
      render json: { message: @computer.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @computer.update(computer_params)
      render :show, status: :ok
    else
      render json: { message: @computer.errors }, status: :unprocessable_entity
    end
  end
  
  private

    def set_computer
      @computer = Computer.find(params[:id])
    end

    def computer_params
      params.require(:computer).permit(:name, :model, :manufacturer, 
          :operating_system, :cpu, :serial_number, :mb_serial_number, :key)
    end

    def authorize_computer
      render json: { message: "Unauthorized" }, status: :unauthorized unless @account == @computer.account
    end
  end

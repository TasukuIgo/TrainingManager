class Admin::TrainingsController < ApplicationController
  def new
    @training = Training.new
  end

  def create
    @training = Training.new(training_params)
    
    if @training.save
      redirect_to admin_training_path(@training), 
      notice:"研修を作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
  end

  def show
    @training = Training.find(params[:id])
  end

  def edit
  end

  private

  def training_params
    params.require(:training).permit(:title, :description)
  end
end

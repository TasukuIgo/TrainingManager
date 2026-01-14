class Admin::TrainingsController < ApplicationController

# 新規作成ページ用のnewアクション
  def new
    @training = Training.new
  end

# 
  def create
    @training = Training.new(training_params)
    
    if @training.save
      redirect_to admin_training_path(@training), 
      notice: "研修を作成しました。"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @trainings = Training.order(created_at: :desc)
  end

  def show
    @training = Training.find(params[:id])
  end

  def edit
    @training = Training.find(params[:id])
  end

  def update
    @training = Training.find(params[:id])

    if @training.update(training_params)
      redirect_to admin_training_path(@training),
      notice: "研修内容を更新しました。"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def training_params
    params.require(:training).permit(:title, :description)
  end
end

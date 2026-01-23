class Admin::TrainingsController < ApplicationController
  before_action :require_login
  before_action :set_training, only: %i[show edit update destroy]

  def new
    @training = Training.new
  end

  def create
    @training = Training.new(training_params) # materials は除く

    ActiveRecord::Base.transaction do
      @training.save!
      save_materials(@training) if params[:training][:materials].present?
    end

    redirect_to admin_training_path(@training), notice: "研修を作成しました"

  rescue => e
    Rails.logger.error(e)
    respond_to do |format|
      format.html { render :new, status: :unprocessable_entity }
      format.turbo_stream { render :new, status: :unprocessable_entity }
    end
  end


  def index
    @trainings = Training.order(created_at: :asc)
  end

  def show
  end

  def edit
  end

  def update
    ActiveRecord::Base.transaction do
      @training.update!(training_params)

      save_materials(@training)
    end

    redirect_to admin_training_path(@training), notice: "研修内容を更新しました"

  rescue => e
    Rails.logger.error(e)
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @training.destroy
    redirect_to admin_trainings_path, notice: "研修を削除しました"
  end

  private

  def set_training
    @training = Training.find(params[:id])
  end

  def training_params
    params.require(:training).permit(:title, :description)
  end


  def save_materials(training)
    return unless params[:training][:materials].present?

    params[:training][:materials].reject(&:blank?).each do |uploaded_file|
      save_dir = Rails.root.join("storage/materials", training.id.to_s)
      FileUtils.mkdir_p(save_dir)

      file_path = save_dir.join(uploaded_file.original_filename)

      File.open(file_path, "wb") do |file|
        file.write(uploaded_file.read)
      end

      training.materials.create!(
        file_path: file_path.to_s,
        original_filename: uploaded_file.original_filename, # ← ここを修正
        content_type: uploaded_file.content_type
      )
    end
  end

end
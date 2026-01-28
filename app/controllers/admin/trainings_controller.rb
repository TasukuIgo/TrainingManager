class Admin::TrainingsController < ApplicationController
  # ログイン必須
  before_action :require_login
  # show, edit, update, destroy の対象研修を取得
  before_action :set_training, only: %i[show edit update destroy]

  # 新規作成フォーム
  def new
    @training = Training.new
  end

  # 作成処理
  def create
    @training = Training.new(training_params)

    # 複数テーブルを同時に更新する場合は transaction でまとめる
    ActiveRecord::Base.transaction do
      @training.save! # 保存できなければ例外
      save_materials(@training) if params[:training][:materials].present? # ファイル保存
    end

    redirect_to admin_training_path(@training), notice: "研修を作成しました"

  rescue => e
    Rails.logger.error(e) # エラー内容をログに出力
    respond_to do |format|
      format.html { render :new, status: :unprocessable_entity }
      format.turbo_stream { render :new, status: :unprocessable_entity }
    end
  end

  # 一覧表示
  def index
    @trainings = Training.order(updated_at: :desc)
  end

  # 詳細表示
  def show
    # set_training で取得済み
  end

  # 編集フォーム
  def edit
    # set_training で取得済み
  end

  # 更新処理
  def update
    ActiveRecord::Base.transaction do
      @training.update!(training_params)
      save_materials(@training)

      if params[:deleted_material_ids].present?
        params[:deleted_material_ids].each do |id|
          material = @training.materials.find(id)
          file_path = Rails.root.join(
            "public", "materials", @training.id.to_s, material.original_filename
          )
          File.delete(file_path) if File.exist?(file_path)
          material.destroy
        end
      end

      # 研修に紐づく何か（資料など）が変わったら「研修が更新された」扱い
      @training.touch
    end

    redirect_to admin_training_path(@training), notice: "研修を更新しました"

  rescue => e
    Rails.logger.error(e)
    render :edit, status: :unprocessable_entity
  end

  # 削除処理
  def destroy
    @training.destroy
    redirect_to admin_trainings_path, notice: "研修を削除しました"
  end

  private

  # 編集・削除対象の研修を取得
  def set_training
    @training = Training.find(params[:id]) # id で検索
  end

  # 許可されたパラメータのみ受け取る
  def training_params
    params.require(:training).permit(:title, :description)
  end

  # ファイル保存処理
  def save_materials(training)
    return unless params[:training][:materials].present?

    params[:training][:materials].reject(&:blank?).each do |uploaded_file|
      # Public 配下の保存先
      save_dir = Rails.root.join("public", "materials", training.id.to_s)
      FileUtils.mkdir_p(save_dir) unless Dir.exist?(save_dir)

      file_path = save_dir.join(uploaded_file.original_filename)

      # ファイル書き込み
      File.open(file_path, "wb") do |file|
        file.write(uploaded_file.read)
      end

      # DB に保存
      training.materials.create!(
        file_path: "/materials/#{training.id}/#{uploaded_file.original_filename}", # URL用
        original_filename: uploaded_file.original_filename,
        content_type: uploaded_file.content_type
      )
    end
  end
end

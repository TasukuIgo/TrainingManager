class Material < ApplicationRecord
  belongs_to :training

  validate :pdf_only
  validate :file_size_limit

  private

  def pdf_only
    return if file_path.blank?
    unless File.extname(file_path).downcase == ".pdf"
      errors.add(:base, "PDFファイルのみアップロード可能です")
    end
  end

  def file_size_limit
    return if file_path.blank?
    full_path = Rails.root.join(file_path) # publicやstorageのパス
    return unless File.exist?(full_path)
    if File.size(full_path) > 20.megabytes
      errors.add(:base, "ファイルサイズは20MB以下にしてください")
    end
  end
end

class Note < ApplicationRecord
  validate :title_is_present

  private

  def title_is_present
    errors.add(:title, "を入力してください") if title.to_s.strip.empty?
  end
end

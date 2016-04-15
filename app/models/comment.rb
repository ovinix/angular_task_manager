class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :task

  mount_uploader :file, FileUploader

  has_one :list, through: :task

  validates :user_id, presence: true
  validates :task_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  validate :file_size

  private

    # Validates the size of an uploaded file.
    def file_size
      if file.size > 1.megabytes
        errors.add(:file, "should be less than 1MB")
      end
    end

end

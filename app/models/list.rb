class List < ActiveRecord::Base
  belongs_to :user
  has_many :tasks, dependent: :destroy
  has_many :comments, through: :task

  default_scope -> { order(created_at: :desc) }
  
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }

end

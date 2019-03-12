class Task < ActiveRecord::Base
  include DateTimeConverter
  include IndexCheck

  belongs_to :project
  has_many :comments

  has_many :user_tasks, foreign_key: "assigned_task_id"
  has_many :assigned_users, through: :user_tasks
  belongs_to :owner, class_name: "User"

  enum status: [:active, :complete, :inactive, :progress]

  validates :name, :description, :due_date, :status, :project_id, presence: true
  
  scope :active, -> { where(status: 0)}
  scope :complete, -> { where(status: 1) }
  scope :inactive, -> { where(status: 2)}
  scope :progress, -> { where(status: 3)}
  scope :overdue, -> { where("due_date < ? AND status = ?", Date.today, 0)}
  before_save :assign_status

  def assign_status
    self.status = 2 if (self.status == nil)
  end

  def overdue?
    self.due_date < Date.today ? true : false
  end

end 
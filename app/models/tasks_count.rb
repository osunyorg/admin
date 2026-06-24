# == Schema Information
#
# Table name: tasks_counts
#
#  id            :bigint           not null, primary key
#  tasks_pending :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class TasksCount < ApplicationRecord
  validates :tasks_pending, presence: true, numericality: { greater_than_or_equal_to: 0 }
end

# Course model
class Course < ActiveRecord::Base
  include Activity
  validates :course_name, presence: true, length: \
  { minimum: 1, maximum: 60 }, format: { with: /\A[a-zA-Z0-9._" "-\/]+\Z/ }
  validates :section_name, length: \
  { minimum: 1, maximum: 30 }, format: { with: /\A[a-zA-Z0-9_" "-]+\Z/ }
  validates :code, uniqueness: true, presence: true, length: \
  { minimum: 1, maximum: 20 }, format: { with: /\A[a-zA-Z0-9._" "-]+\Z/ }

  has_many :batches, dependent: :destroy
  has_many :batch_groups
  accepts_nested_attributes_for :batches
  has_many :class_designations
  has_many :ranking_levels
  scope :shod, ->(id) { where(id: id).take }

  # method return full name by joining course name section name
  def full_name
    [course_name, section_name].join(' ')
  end

  # This action is used to set the maximum rank level and maximum
  # rank level prioriy. and return the rank level1 object.
  def max(max_rank, rank_lev1)
    max_rank = 0.to_i if max_rank.nil?
    rank_lev1.prioriy = max_rank + 1.to_i
    rank_lev1
  end

  # This action is used to increase the ranking level from bottom to top.
  def increase_logic(rank_levels, selected)
    previous = 0.to_i
    temp = nil
    rank_levels.each do |p|
      temp = p if (selected == previous)
      if (selected + 1.to_i == previous)
        current = p.prioriy
        previous_pri = temp.prioriy
        p.update(prioriy: nil)
        temp.update(prioriy: current)
        p.update(prioriy: previous_pri)
      end
      previous += 1.to_i
    end
  end

  # This action is used to decrease the ranking level from top to bottom.
  def decrease_logic(rank_levels, selected)
    next_pri = 0.to_i
    temp = nil
    rank_levels.each do |p|
      temp = p if (selected - 1.to_i == next_pri)
      if (selected == next_pri)
        current = p.prioriy
        next_priority = temp.prioriy
        p.update(prioriy: nil)
        temp.update(prioriy: current)
        p.update(prioriy: next_priority)
      end
      next_pri += 1.to_i
    end
  end
end

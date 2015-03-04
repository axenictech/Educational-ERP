# Class Timing Model
class ClassTiming < ActiveRecord::Base
  include Activity
  has_many :timetable_entries
  belongs_to :batch
  validates :name, presence: true, length: { \
    minimum: 1, maximum: 20 }, format: { with: /\A[a-zA-Z0-9" "-]+\Z/ }
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_cannot_be_less_than_start_time
  # validate  :validate_class_timing
  scope :shod, ->(id) { where(id: id).take }
  scope :is_break, -> { where(is_break: false) }

  # This is a validation action and add error if end time is less than start date.
  # this is for validation of class_timimg, class start time
  # can not be greater that class end time
  def end_time_cannot_be_less_than_start_time
    if end_time.present? && end_time < start_time
      errors.add(:end_time, "can't be less than start time")
    end
  end

  # return full time by joining start time and end time
  def full_time
    [start_time.strftime('%I:%M %p'), end_time.strftime('%I:%M %p')].join('-')
  end

  # def validate_class_timing
  #   unless self.start_time.nil? or self.end_time.nil?
  #   self_check= self.new_record? ? "" : "id != #{self.id} and "
  #   start_overlap = !ClassTiming.where(:first, :conditions=>[self_check+"start_time < ? and end_time > ?", self.start_time,self.start_time]).nil?
  #   # end_overlap = !ClassTiming.where(:first, :conditions=>[self_check+"start_time < ? and end_time > ? and is_deleted = ? and batch_id #{self.batch_id.nil? ? 'is null' : '='+ self.batch_id.to_s}", self.end_time,self.end_time,false]).nil?
  #    # between_overlap = !ClassTiming.where(:first, :conditions=>[self_check+"start_time < ? and end_time > ? and is_deleted = ? and batch_id #{self.batch_id.nil? ? 'is null' : '='+ self.batch_id.to_s}",self.end_time, self.start_time,false]).nil?
  #   errors.add(:start_time, "overlap_existing_class_timing") if start_overlap
  #   # errors.add(:end_time, "overlap_existing_class_timing") if end_overlap
  #   #  errors.add(:class_time,"overlaps_with_existing") if between_overlap
  #     end
  #   end
end

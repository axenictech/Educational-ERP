# Time Table Model
class TimeTable < ActiveRecord::Base
  include Activity
  has_many :time_table_entries, dependent: :destroy
  scope :shod, ->(id) { where(id: id).take }

  # get time table date between start_date and end_date
  def self.time_table_date(timetable)
    TimeTable.where('time_tables.start_date <= ?
      AND time_tables.end_date >= ?', timetable, timetable)
  end

  # create time table and validation
  def create_time_table(t)
    error = false
    create_error(t)
    fully_overlapping = TimeTable.where('end_date <= ? AND
      start_date >= ?', t.end_date, t.start_date)
    unless fully_overlapping.empty?
      error = true
      t.errors.add(:end_date, 'timetable in between given dates')
    end
    if t.end_date < t.start_date
      error = true
      t.errors.add(:end_date, "can't be less than start date")
    end
    error
  end

  # create time table and validation
  def create_error(t)
    previous = TimeTable.where('end_date >= ? AND
      start_date <= ?', t.start_date, t.start_date)
    unless previous.empty?
      t.errors.add(:start_date, 'is within the range of another timetable')
    end
    foreword = TimeTable.where('end_date >= ? AND
      start_date <= ?', t.end_date, t.end_date)
    unless foreword.empty?
      t.errors.add(:end_date, 'is within the range of another timetable')
    end
  end

  # create time table and validation
  def self.tte_for_the_day(batch, date)
    entries = TimeTableEntry.joins(:time_table, :class_timing, :weekday).where('
    time_tables.start_date<= ? AND time_tables.end_date >=?
    AND time_table_entries.batch_id = ?', date, date, batch.id)
    if entries.empty?
      today = []
    else
      today = entries.select { |a| a.weekday.day_of_week == date.wday }
    end
    today
  end

  # upadate method update a class timing,
  # and it accepts a hash containing the attributes that you want to update.
  def update_time(time)
    if time.start_date <= Date.today \
       && time.end_date >= Date.today
    end
    return if time.start_date > Date.today \
       && time.end_date > Date.today
  end

  # list all weekaday of selected time table
  def self.weekday_teacher(wt)
    wt.collect(&:weekday) \
      .uniq.sort! { |a, b| a.weekday <=> b.weekday }
  end

  # list all class timing of selected time table
  def self.class_teacher(ct)
    ct.collect(&:class_timing) \
      .uniq.sort! { |a, b| a.start_time <=> b.start_time }
  end

  # list all employee of selected timetable
  def self.employee_teacher(et)
    et.collect(&:employee).uniq
  end

  # concat start_date and end_date and make make strinf fulltime
  def full_time
    start_date.strftime('%d %b %Y') + '-' + end_date.strftime('%d %b %Y')
  end
end

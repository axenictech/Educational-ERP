# Weekday model
class Weekday < ActiveRecord::Base
  include Activity
  belongs_to :batch
  scope :shod, ->(id) { where(id: id).take }
  scope :day, -> \
  { %w(Sunday Monday Tuesday Wednesday Thursday Friday Saturday) }
  scope :days, -> { %w(0 1 2 3 4 5 6) }

  # Method for set weekdays for selectd vbatch,
  # first destroy all present weekdays unless its not nil,
  # then create weekday and assign day of week for selectd batch
  def self.set_day(batch, weekdays)
    present_weekdays = Weekday.where(batch_id: batch)
    present_weekdays.destroy_all unless present_weekdays.nil?
    weekdays.each  do |w|
      Weekday.create(batch_id: batch, weekday: day[w.to_i])
    end
    Batch.shod(batch)
  end
end

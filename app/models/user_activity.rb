# UserActivity model
class UserActivity < ActiveRecord::Base
  belongs_to :user
  scope :shod, ->(id) { where(id: id).take }

  # method used for track activity and create user activity
  def self.activity(name, id, action)
    activity = UserActivity.new
    activity.user_id = User.current.id
    activity.modelname = name
    activity.model_id = id
    activity.action = action
    activity.save
  end

  # get all attributed of selected modelname
  def activity_model
    (Object.const_get modelname).shod(model_id).attributes
  end
end

class UserPrivilege < ActiveRecord::Base
  belongs_to :user
  belongs_to :privilege
end

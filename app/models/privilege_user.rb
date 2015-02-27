# PrivilegeUser
class PrivilegeUser < ActiveRecord::Base
  include Activity
  belongs_to :privilege
  belongs_to :user
  belongs_to :privilege_tag
  scope :shod, ->(id) { where(id: id).take }

  def self.privilege_update(privilege_tag, user)
    unless privilege_tag.nil?
      privilege_tag.each do |k|
        k[1][:name].each do |l|
          PrivilegeUser.find_or_create_by(user_id: user.id,
                                          privilege_id: l,
                                          privilege_tag_id: k[0])
        end
      end
    end
  end
end

class PrivilegeUser < ActiveRecord::Base
	 include Activity
  belongs_to :privilege
  belongs_to :user
  belongs_to :privilege_tag
  scope :shod, ->(id) { where(id: id).take }

  def self.privilege_update(privilege_tag, user)
    if privilege_tag.present?
      privilege_tag.each  do |p_t|
        privileges = PrivilegeTag.find(p_t).privileges.all

        next if  privileges.nil?
        privileges.each do |p|
          PrivilegeUser.create(user_id: user.id, privilege_id: p.id)
        end
      end
    end
  end
end

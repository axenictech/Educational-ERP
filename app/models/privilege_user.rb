class PrivilegeUser < ActiveRecord::Base
  # include Activity
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

  #  privilege_tag[:name].each do |k|
  #    p"Timetable=>",k
  # end
  #  privilege_tag[:name].each do |k|
  #    p"Student=>",k
  # end
  #  privilege_tag[:name].each do |k|
  #    p"Examination=>",k
  # end
  #  privilege_tag[:name].each do |k|
  #    p"Leave=>",k
  # end

  #   if privilege_tag.present?
  #     privilege_tag.each  do |p_t|
  #       privileges = PrivilegeTag.find(p_t).privileges.all

  #       next if  privileges.nil?
  #       privileges.each do |p|
  #         PrivilegeUser.create(user_id: user.id, privilege_id: p.id)
  #       end
  #     end
  #   end
  # end
end

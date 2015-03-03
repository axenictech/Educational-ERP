# country
class Country < ActiveRecord::Base
  # include Activity
  def self.per(emp)
    find(emp.country_id).name unless emp.country_id.nil?
  end

  def self.home_country(emp)
    find(emp.home_country_id).name unless emp.home_country_id.nil?
  end

  def self.office_country(emp)
    find(emp.office_country_id).name unless emp.office_country_id.nil?
  end

  def self.findcountry(emp)
    (emp.country_id).name unless emp.country_id.nil?
  end
end

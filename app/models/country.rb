# Country model
class Country < ActiveRecord::Base
  # include Activity
  
  # method find & return country name for selected employee
  def self.per(emp)
    find(emp.country_id).name unless emp.country_id.nil?
  end

  # method find & return home country name for selected employee
  def self.home_country(emp)
    find(emp.home_country_id).name unless emp.home_country_id.nil?
  end

  # method find & return office name for selected employee
  def self.office_country(emp)
    find(emp.office_country_id).name unless emp.office_country_id.nil?
  end
  
  # method find & return country name for selected employee
  def self.findcountry(emp)
    (emp.country_id).name unless emp.country_id.nil?
  end
end

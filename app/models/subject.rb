class Subject < ActiveRecord::Base

	belongs_to :batch
  	belongs_to :elective_group
  	
  	validates :name, presence: true, length:{minimum:3,maximum: 20}, format:{ with: /\A[a-zA-Z0-9#+" "-]+\Z/}
	validates :code, presence: true, length:{minimum:3,maximum: 10}
	validates :max_weekly_classes, presence: true, length:{maximum: 2}, numericality:{only_integer: true,less_than:20,greater_than:0}

end
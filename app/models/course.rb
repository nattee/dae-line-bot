class Course < ApplicationRecord
  belongs_to :race
  has_many :stations
end

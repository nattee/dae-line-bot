class Run < ApplicationRecord
  belongs_to :athlete
  belongs_to :course
  has_many :plans
end

class Run < ApplicationRecord
  belongs_to :athlete
  belongs_to :course
  has_many :plans, dependent: :destroy
  has_many :checkins, dependent: :destroy
end

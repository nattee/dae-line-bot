class Run < ApplicationRecord
  belongs_to :athlete
  belongs_to :course
  has_many :plans, dependent: :destroy_all
  has_many :checkins, dependent: :destroy_all
end

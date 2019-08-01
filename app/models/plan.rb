class Plan < ApplicationRecord
  belongs_to :run
  belongs_to :station
end

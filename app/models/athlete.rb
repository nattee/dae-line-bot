class Athlete < ApplicationRecord
  has_many :runs

  def proper_name
    return name unless name.nil?
    return line_name
  end
end

class Athlete < ApplicationRecord
  has_many :runs

  def proper_name
    return name unless name.nil?
    return line_name unless line_name.nil?
    return bib
  end
end

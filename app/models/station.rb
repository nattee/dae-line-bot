class Station < ApplicationRecord
  belongs_to :course

  def long_name
    "#{code} #{name.empty? ? '' : "(#{name})"}"
  end
end

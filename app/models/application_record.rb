class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def min_to_human(minute)
    sprintf("%02d:%02d",(minute/60).to_i,minute % 60)
  end

  def cm6_time(datetime)
    datetime.strftime("%H:%M ของวันที่ %e") if datetime
  end
end

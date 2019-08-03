class Run < ApplicationRecord
  belongs_to :athlete
  belongs_to :course
  has_many :plans, dependent: :destroy
  has_many :checkins, dependent: :destroy

  def chilling_trail_status
    return "ยังไม่เริ่ม" if status == "WAIT"
    st = ""
    if status == "FIN"
      st = "เข้าเส้นชัยแล้ว"
    else
      st = "#{status} #{ct_station} #{sprintf("%.1f",ct_distance || 0)}km"
    end
    st += ct_checkin_time.strftime(" @%H:%M %-daug") if ct_checkin_time
    return st
  end

  def update_station(dist)
      station_code = nil
      last_dist = 0
      course.stations.order('distance').each do |station|
        curr_dist = station.distance - last_dist
        last_dist = station.distance

        #skip if this is not what we want
        if station.distance <= dist
          station_code = station.code
          next
        end
      end

      self.station = station_code
      self.save
  end
end

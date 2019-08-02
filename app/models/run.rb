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
    st += ct_checkin_time.strftime("เมื่อ %H:%M ของวันที่ %-d") if ct_checkin 
    return st
  end
end

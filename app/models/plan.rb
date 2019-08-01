class Plan < ApplicationRecord
  belongs_to :run
  belongs_to :station

  def summary_text
    return "จาก #{station.code} ระยะทาง #{sprintf("%.1f",dist)} gain #{station.ascent} loss #{station.descent} pace #{pace} เวลารวม #{min_to_human(total_minute)} เวลาถึงเป้าหมาย #{cm6_time(worldtime)} (#{margin_text})"
  end

  def margin_text
    return unless margin_minute
    if margin_minute < 0
      return "ไม่ทัน CUTOFF"
    else
      return "ได้มาร์จิน #{min_to_human(margin_minute)}"
    end
  end
end

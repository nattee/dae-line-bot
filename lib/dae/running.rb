module Dae
  class Running
    def initialize(end_time = nil)
      @end_time = end_time || Time.parse('2019-04-28 15:45:00 +0700')
      @total_dist = 63.0
      @total_lap = 20.0
      @lap_dist = 2.1
    end

    def read_end_time
      p = Parameter.find(1)
      @end_time = Time.parse(p.value)
    end

    def set_end_time(time)
      p = Parameter.find_or_initialize_by(id: 1)
      p.value = time.in_time_zone.to_s
      p.save
    end

    def respond_to(event,client)

      user_text = event.message['text']
      result = process_text(user_text)
      if result
        profile_resp = client.get_profile(event['source']['userId'])
        hash = JSON.parse profile_resp.body
        user_name = hash['displayName'] || 'ไม่ได้แอดผมเป็นเพื่อน ผมเลยไม่รู้จักชื่อคุณ'

        #if user does not befriend the bot, hash['displayName'] will be nil (and make everyting failed... returning nil)
        reply_text = user_name+"\n"+result

        #build reply and response
        message = {
          type: 'text',
          text: reply_text
        }
        client.reply_message(event['replyToken'], message) if result
      end
    end

    def remaining_time_in_minutes
      return ((@end_time - Time.zone.now)/60).to_i
    end

    def remaining_dist_in_km(text)
      case text.strip
      when /^([0-9\.]+)\s*(km|โล|k)$/
        my_dist = $1.to_f
      when /^([0-9\.]+)\s*(รอบ)$/
        puts $1
        my_lap = $1.to_f
        my_dist = my_lap * @lap_dist
      else
        return nil
      end
      remain = @total_dist - my_dist
      return remain
    end

    def process_text(text)
      r = special_command(text)
      return r + "\n" + 'รับทราบ ปฏิบัติ!!!' if r

      read_end_time
      t = remaining_time_in_minutes
      d = remaining_dist_in_km(text)
      return nil unless d && d.is_a?(Numeric)
      return 'ครบแล้วครับพี่!!!! พอเหอะ' if d <= 0
      d_text = sprintf("%.2f",d)
      pace = t/d
      a = <<~EOS
      เหลือเวลา #{t} นาที
      เหลือระยะทาง #{d_text} โล
      ต้องวิ่งเพซ #{pace_text(pace)} เป็นอย่างน้อยนะจ๊ะ
      EOS
      return a
    end

    def special_command(text)
      case text.strip
      when /^ท่านเมียสั่ง setend (.*)$/
        t = Time.parse("2019-04-28 #{$1} +0700")
        set_end_time(t)
        return "ตั้งเวลาจบการวิ่งเป็น #{t.to_s}"
      end
      return nil
    end

    def pace_text(pace)
      frac = (pace - pace.to_i).abs
      sec = frac * 60
      return sprintf("%d:%02d",pace.to_i,sec)
    end
  end
end

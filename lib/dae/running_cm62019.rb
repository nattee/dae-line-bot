module Dae
  class RunningCM62019
    ENCOURAGE_TEXT = ['สู้ ๆ ครับ', 'ขอให้จบสวย ๆ', 'สบาย ๆ ระดับนี้แล้ว', 'วิ่งให้สนุกครับ!']
    def initialize(end_time = nil)
      @end_time = end_time || Time.parse('2019-04-28 15:45:00 +0700')
      @total_dist = 63.0
      @total_lap = 20.0
      @lap_dist = 2.1
    end

    #main callback function
    def respond_to(event,client)
      @message = {
        type: 'text',
        text: ''
      }
      @event = event
      @client = client

      if process_text
        @client.reply_message(event['replyToken'], @message)
      end
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

    def process_text
      text = @event.message['text']
      return true if special_command(text)

      case text.strip
      when /^ลงทะเบียน (CM[1-6]) bib (\w{,10})/
        return register($1,$2)
      when /^update cm6/i
        return show_update
      else
        return true if funny_response(text)
      end

      return false
    end

    def special_command(text)
      case text.strip
      when /^ท่านเมียสั่ง! setend (.*)$/
        t = Time.parse("2019-04-28 #{$1} +0700")
        set_end_time(t)
        make_special_response("ตั้งเวลาจบการวิ่งเป็น #{t.to_s}")
        return true
      end
      return false
    end

    def make_special_response(text)
      @message[:text] = "#{text} \nรับทราบ ปฏิบัติ!!!"
    end

    def register(course_name,bib)
      if client_is_friend?
        course = Course.where(title: course_name).first
        unless course
          @message[:text] = "#{@sender_name} ไม่รู้จักงาน #{course_name}"
          return true
        end

        puts @event
        runner = Athlete.find_or_create_by(line_id: @event['source']['userId'])
        runner.line_name = @sender_name
        runner.save
        run = Run.find_or_create_by(athlete: runner,course: course)
        run.bib = bib
        run.save

        @message[:text] = "OK พี่#{@sender_name} จะวิ่งงาน #{course.title} ระยะ #{course.distance}km ด้วยหมายเลข #{bib} #{encourage_text}"
      else
        #response with default non-friend
      end
      return true
    end

    def show_update
      resp = ""
      Course.where(race_id: 1).all.each.with_index do |course,i|
        has_runner = false
        Run.where(course: course).each.with_index do |run,j|
          resp += course.title + ":\n" if j == 0
          resp += "#{run.athlete.line_name} #{run.bib}\n"
          has_runner = true
        end
        resp += "\n" if has_runner
      end


      @message[:text] = resp
      return true

    end

    def pace_text(pace)
      frac = (pace - pace.to_i).abs
      sec = frac * 60
      return sprintf("%d:%02d",pace.to_i,sec)
    end

    def funny_response(text)
      case text.strip
      when /^หิวมั้ย$/
        @message[:text] = 'หิวมาก พร้อมโหลด'
        return true
      when /^ฝากแด้$/, /^@ฝากแด้$/
        resp = ['คร้าบบบบ???'], ['อิหยัง?'], ['มีไรให้รับใช้ครับ']
        @message[:text] = resp.sample
        return true
      end
      return false
    end

    def client_is_friend?
      profile_resp = @client.get_profile(@event['source']['userId'])
      hash = JSON.parse profile_resp.body
      @sender_name = hash['displayName']
      if @sender_name.nil?
        @message[:text] = 'ไม่ได้แอดผมเป็นเพื่อน ผมเลยไม่รู้จักชื่อคุณ ช่วยแอดผมเป็นเพื่อนก่อนนะครับ'
        return false
      else
        return true
      end
    end

    def encourage_text
      return ENCOURAGE_TEXT.sample

    end

  end
end

require 'rest-client'
require 'json'

module Dae
  class RunningCM62019
    ENCOURAGE_TEXT = ['สู้ ๆ ครับ', 'ขอให้จบสวย ๆ', 'สบาย ๆ ระดับนี้แล้ว', 'วิ่งให้สนุกครับ!', 'ลุยยยยย']
    def initialize(end_time = nil)
      @message = {
        type: 'text',
        text: ''
      }
    end

    #main callback function
    def respond_to(event,client)
      @event = event
      @client = client

      if process_text
        @client.reply_message(event['replyToken'], @message)
      end
    end

    def remaining_time_in_minutes(cutoff_time)
      return ((cutoff_time - Time.zone.now)/60).to_i
    end

    def process_text
      text = @event.message['text']
      return true if special_command(text)

      case text.strip
      when /^ลงทะเบียน (CM[1-6]) bib (\w{,10})/
        return register($1,$2)
      when /^update cm6/i
        return show_update
      when /^progress cm6/i
        call_chilling_trail_all_runner
        return progress_text
      when /^([0-9\.]+)\s*(km|โล|k)$/
        my_dist = $1.to_f
        return pace_query(my_dist)
      else
        return funny_response(text)
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

    def pace_query(dist)
      if client_is_friend?
        runner = Athlete.find_or_create_by(line_id: @event['source']['userId'])
        Run.where(athlete: runner).each do |run|
          #find next station,cutoff, etc
          next_station = nil
          next_cutoff = nil
          cutoff_dist = nil
          cutoff_station = nil
          run.course.stations.order('distance').each do |station|
            puts "#{station.code} #{station.distance}"
            next if station.distance <= dist
            next_dist = station.distance unless next_dist
            if station.cutoff
              next_cutoff = station.cutoff
              cutoff_dist = station.distance
              cutoff_station = "#{station.code} #{station.name}"
              break
            end
          end

          #calculate
          d = cutoff_dist - dist
          t = remaining_time_in_minutes(next_cutoff)
          d_text = sprintf("%.2f",d)
          pace = t/d

          #response
          @message[:text] = <<~EOS
          cutoff ต่อไปที่ #{cutoff_station} ตอน #{next_cutoff.strftime("%H:%M ของวันที่ %e")}
          เหลือเวลา #{t} นาที
          เหลือระยะทาง #{d_text} โล
          ต้องวิ่งเพซ #{pace_text(pace)} เป็นอย่างน้อยนะจ๊ะ
          สู้ ๆ
          EOS
        end
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
      when /^@{0,1}ฝากแด้$/
        if client_is_friend?
          resp = ['คร้าบบบบ???', 'อิหยัง?', 'มีไรให้รับใช้ครับ']
          @message[:text] = resp.sample + " พี่ @#{@sender_name}"
        else
        end
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

    def progress_text
      resp = ""
      Course.where(race_id: 1).all.each.with_index do |course,i|
        has_runner = false
        last_station = 'hahaha'
        Run.where(course: course).order('current_dist').each.with_index do |run,j|
          #display course name
          resp += course.title + ":\n" if j == 0

          #display station name
          if last_station != run.station
            last_station = run.station
            if last_station.nil? || last_station.empty?
              resp += "ยังไม่เริ่ม: "
            else
              resp += "ผ่าน#{last_station}แล้ว: "
            end
          end

          resp += ',' if j != 0
          resp += " #{run.athlete.line_name}"
          has_runner = true
        end
        resp += "\n" if has_runner
      end

      @message[:text] = resp
      return true
    end

    def call_chilling_trail_all_runner
      Course.where(race_id: 1).all.each.with_index do |course,i|
        Run.where(course: course).order('current_dist').each.with_index do |run,j|
          chilling_trail_update(run.bib)
        end
      end
    end

    def chilling_trail_update(bib)
      #find the ahtlete
      run = Run.where(bib: bib).first

      #quit if this bib was updated in the last 10 secs.
      return nil unless run && (run.last_online_call_timestamp.nil? || run.last_online_call_timestamp < 30.second.ago)

      begin
        response = RestClient.get("https://race.chillingtrail.run/2019/cm6/r-json/#{bib}")
        hash = JSON.parse(response)

        #if bib not found
        return nil unless hash

        #update
        run.last_online_call_timestamp = Time.zone.now

        begin
          run.status = hash['progress']['state']
          run.current_dist = hash['progress']['distance']
          run.start_time = hash['progress']['startTime']
          run.station = hash['progress']['station']
        end

        run.save
      rescue RestClient::ExceptionWithResponse => e
        return nil
      end
    end

  end
end

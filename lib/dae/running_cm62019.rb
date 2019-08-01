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
      when /^ลงทะเบียน (CM[1-6]) bib (\w{,10}) แผน (([0-9]+\.?[0-9]*))/i
        return register($1,$2,$3)
      when /^ลงทะเบียน (CM[1-6]) bib (\w{,10})/i
        return register($1,$2)
      when /^ยกเลิกลงทะเบียน (CM[1-6])/i
        return unregister($1)
      when /^update cm6/i
        return show_update
      when /^progress cm6/i
        call_chilling_trail_all_runner
        return progress_text
      when /^([0-9\.]+)\s*(km|โล|k)$/i
        my_dist = $1.to_f
        return dist_update(my_dist)
      when /^map/i
        return show_map
      when /^plan text/i
        return show_plan_text
      when /^plan/i
        return show_plan_pic
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

    def register(course_name,bib,target = nil)
      course_name.upcase!
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

        #set plans
        run.plans.destroy_all
        if target
          @message[:text] += "\n\nแผน #{target} ชั่วโมง\n(กราบขอบพระคุณข้อมูลจาก Chilling Trail)\nhttps://plan.chillingtrail.run/CM6_2019_index.php"
          run.plan_hour = target
          run.save
          chilling_trail_update_plan(runner,course,target)
        end
      else
        #response with default non-friend
      end
      return true
    end

    def unregister(course_name)
      course_name.upcase!
      if client_is_friend?
        course = Course.where(title: course_name).first
        unless course
          @message[:text] = "#{@sender_name} ไม่รู้จักงาน #{course_name}"
          return true
        end

        runner = Athlete.find_or_create_by(line_id: @event['source']['userId'])
        runner.line_name = @sender_name
        runner.save
        runs = Run.where(athlete: runner,course: course)
        if runs.count > 0
          runs.destroy_all
          @message[:text] = "#{@sender_name} ยกเลิก #{course_name} แล้ว"
        else
          @message[:text] = "#{@sender_name} ไม่ได้ลงทะเบียน #{course_name} ไว้"
        end
      else
        #response with default non-friend
      end
      return true
    end

    def show_map
      if client_is_friend?
        runner = Athlete.find_or_create_by(line_id: @event['source']['userId'])

        return true unless registered?

        Run.where(athlete: runner).each do |run|
            @message[:type] = "image"
            @message[:originalContentUrl] = "https://line.nattee.net/cm6-2019/#{run.course.title}_map.jpg"
            @message[:previewImageUrl] = "https://line.nattee.net/cm6-2019/#{run.course.title}_map_preview.jpg"
        end
      end
      return true
    end

    def show_plan_text
      if client_is_friend?
        runner = Athlete.find_or_create_by(line_id: @event['source']['userId'])

        return true unless registered?

        resp = "แผน\n"
        Run.where(athlete: runner).each do |run|
          if run.plans.count == 0
            @message[:text] = "ไม่ได้ระบุแผนไว้ ช่วยระบุแผนด้วยคำสั่ง \"ลงทะเบียน #{run.course.title} bib #{run.bib} แผน XX\" โดยให้ X ระบุจำนวนชั่วโมงที่ต้องใช้ \n\n(กราบขอบพระคุณข้อมูลจาก Chilling Trail)\nhttps://plan.chillingtrail.run/CM6_2019_index.php"
            return
          end
          run.plans.each do |plan|
            resp += plan.summary_text + "\n\n"
          end
          @message[:text] = resp
        end
      end
      return true
    end

    def show_plan_pic
      if client_is_friend?
        runner = Athlete.find_or_create_by(line_id: @event['source']['userId'])

        return true unless registered?

        Run.where(athlete: runner).each do |run|
          if run.plans.count == 0
            @message[:text] = "ไม่ได้ระบุแผนไว้ ช่วยระบุแผนด้วยคำสั่ง \"ลงทะเบียน #{run.course.title} bib #{run.bib} แผน XX\" โดยให้ X ระบุจำนวนชั่วโมงที่ต้องใช้ \n\n(กราบขอบพระคุณข้อมูลจาก Chilling Trail)\nhttps://plan.chillingtrail.run/CM6_2019_index.php"
            return
          end

          #show plan image
          @message = Array.new
          @message << {
            type: "image",
            originalContentUrl: "https://line.nattee.net/cm6-2019/PLAN-#{run.course.title}-#{sprintf("%.02f",run.plan_hour)}.jpg",
            previewImageUrl: "https://line.nattee.net/cm6-2019/preview-PLAN-#{run.course.title}-#{sprintf("%.02f",run.plan_hour)}.jpg",
          }
          @message << {
            type: 'text',
            text: "(กราบขอบพระคุณข้อมูลจาก Chilling Trail)\nhttps://plan.chillingtrail.run/CM6_2019_index.php",
          }
        end
      end
      return true
    end

    def dist_update(dist)
      if client_is_friend?
        runner = Athlete.find_or_create_by(line_id: @event['source']['userId'])
        Run.where(athlete: runner).each do |run|
          # get cutoff text
          cutoff_response = build_cutoff_response(dist,run)
          @message[:text] = cutoff_response
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

    def build_cutoff_response(dist,run)
      #find next cutoff
      next_cutoff = nil
      cutoff_dist = nil
      cutoff_station = nil
      station_code = nil
      section_text = nil
      last_dist = 0
      run.course.stations.order('distance').each do |station|
        curr_dist = station.distance - last_dist
        last_dist = station.distance

        #skip if this is not what we want
        next if station.distance <= dist

        next_dist = station.distance unless next_dist

        #found current section
        unless section_text
          section_text = <<~EOS
          กำลังวิ่งไป  #{station.long_name}
          ช่วงนี้ ระยะ #{sprintf("%.1f",curr_dist)} gain #{station.ascent} loss #{station.descent}
          EOS

          #check if we have plan
          run.plans.where(station: station).each do |plan|
            plan_target_time = plan.cm6_time(plan.worldtime)
            plan_remaining = remaining_time_in_minutes(plan.worldtime)
            section_text += "\nตามแผน #{run.plan_hour} ชั่วโมง ต้องไปถึงภายใน #{plan_remaining} นาที (เวลา #{plan_target_time})\n"
            if plan.margin_minute
              section_text += plan.margin_text + "\n"
            else
              section_text += "ช่วงนี้ไม่มี cut-off\n"
            end
          end
        end


        #find cutoff
        if station.cutoff
          next_cutoff = station.cutoff
          cutoff_dist = station.distance
          cutoff_station = station.long_name
          station_code = station.code
          break
        end
      end

      if next_cutoff
        #calculate
        d = cutoff_dist - dist
        t = remaining_time_in_minutes(next_cutoff)
        d_text = sprintf("%.2f",d)
        pace = t/d

        run.station = station_code
        run.current_dist = dist
        run.save

        #response
        cutoff_text = <<~EOS
        cutoff ต่อไปที่ #{cutoff_station} 
        ตอน #{next_cutoff.strftime("%H:%M ของวันที่ %e")}
        เหลือเวลา #{t} นาที
        เหลือระยะทาง #{d_text} โล
        ต้องวิ่งเพซ #{pace_text(pace)} เป็นอย่างน้อยนะจ๊ะ
        สู้ ๆ
        EOS

        return section_text + "\n" + cutoff_text
      else
        return "จบแล้ว!!! เยี่ยมมากครับ"
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
          resp += course.title + "" if j == 0

          #display station name
          if last_station != run.station
            last_station = run.station
            if last_station.nil? || last_station.empty?
              resp += "\nยังไม่เริ่ม: "
            else
              resp += "\nผ่าน #{last_station} แล้ว: "
            end
          else
            resp += ','
          end

          resp += " #{run.athlete.line_name}"
          has_runner = true
        end
        resp += "\n\n" if has_runner
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

    def chilling_trail_update_plan(athlete,course,target)
      begin
        response = RestClient.get("https://plan.chillingtrail.run/CM6_2019.php?distance=#{course.title}&target=#{target}&output=json")
        array = JSON.parse(response)

        return nil unless array


        run = Run.where(athlete: athlete, course: course).first
        run.plans.destroy_all

        i = 0;
        course.stations.order(:distance).each do |station|
          next if station.distance == 0
          while (i < array.count && array[i]['dist'].to_f < station.distance) 
            i += 1
          end
          if i < array.count
            Plan.create(run: run, station: station, dist: array[i]['dist'], total_minute: array[i]['sectionTotalMinute'], worldtime: Time.at(array[i]['sectionRaceTime']).to_datetime, margin_minute: array[i]['sectionMarginMinute'], pace: "#{array[i]['sectionPaceMinute']}:#{array[i]['sectionPaceSecond']}")
          end
        end

        #cache plan picture
        pic_response = RestClient.get("https://plan.chillingtrail.run/CM6_2019.php?distance=#{course.title}&target=#{target}")
        if pic_response.code == 200
          dir = Rails.root.join('public','cm6-2019')
          unless dir.join("PLAN-#{course.title}-#{sprintf("%.02f",target)}.jpg").exist?
            f = File.open(dir.join("PLAN-#{course.title}-#{sprintf("%.02f",target)}.jpg"), "wb")
            f << pic_response.body
            f.close

            #resize
            orig_name = dir.join("PLAN-#{course.title}-#{sprintf("%.02f",target)}.jpg")
            new_name  = dir.join("preview-PLAN-#{course.title}-#{sprintf("%.02f",target)}.jpg")
            cmd = "convert -geometry x240 #{orig_name} #{new_name}"
            system(cmd)
          end
        end
      rescue RestClient::ExceptionWithResponse => e
        return nil
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

    def registered?
      runner = Athlete.where(line_id: @event['source']['userId']).first
      unless runner
        @message[:text] = "#{@sender_name} ยังไม่ได้ลงทะเบียนครับ ช่วยลงทะเบียนก่อนโดยพิมพ์ \"ลงทะเบียน CM2 bib 1234\""
        return false
      end
      run = Run.where(athlete: runner).first
      unless run
        @message[:text] = "#{@sender_name} ยังไม่ได้ลงทะเบียนครับ ช่วยลงทะเบียนก่อนโดยพิมพ์ \"ลงทะเบียน CM2 bib 1234\""
        return false
      end
      return true
    end

  end #class
end

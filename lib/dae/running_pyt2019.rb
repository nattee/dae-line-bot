require 'rest-client'
require 'json'

WEB_URL = ''
PLAN_URL = 'https://plan.chillingtrail.run/plan.php?race=pyt&year=2019'
RACE_URL = 'https://race.chillingtrail.run/2019/pyt/r-json'
RACE_ID = 2

module Dae
  class RunningPYT2019
    ENCOURAGE_TEXT = ['สู้ ๆ ครับ', 'ขอให้จบสวย ๆ', 'สบาย ๆ ระดับนี้แล้ว', 'วิ่งให้สนุกครับ!', 'ลุยยยยย']
    def initialize(end_time = nil)
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
      @message = {
        type: 'text',
        text: ''
      }

      text = @event.message['text']
      return true if special_command(text)

      case text.strip
      when /^ลงทะเบียน pyt ?(15|30|50|70|100|120|166) bib ?(\w{,10}) แผน ?(([0-9]+\.?[0-9]*))/i
        return register("pyt#{$1}",$2,$3)
      when /^ลงทะเบียน pyt ?(15|30|50|70|100|120|166) bib ?(\w{,10})/i
        return register("pyt#{$1}",$2)
      when /^ยกเลิกลงทะเบียน pyt ?(15|30|50|70|100|120|166)/i
        return unregister("pyt#{$1}")
      when /^update pyt/i
        return show_update
      when /^progress unofficial/i
        group_id = (@event['source']['type'] == 'group') ? @event['source']['groupId'] : @event['source']['userId']
        call_chilling_trail_all_runner(group_id)
        return progress_text(group_id,{official: false})
      when /^progress/i
        group_id = (@event['source']['type'] == 'group') ? @event['source']['groupId'] : @event['source']['userId']
        call_chilling_trail_all_runner(group_id)
        return progress_text(group_id,{official: true})
      when /^progress add bib ?(\w{,10})/
        #if @event['source']['type'] == 'group'
        #  group_id = @event['source']['groupId']
        #  return add_bib_to_group($1,group_id)
        #else
        #  @message[:text] = 'คำสั่งนี้ใช้ได้เฉพาะเวลาอยู่ในห้องเท่านั้นครับ'
        #end
        group_id = (@event['source']['type'] == 'group') ? @event['source']['groupId'] : @event['source']['userId']
        return add_bib_to_group($1,group_id)
      when /^([0-9\.]+)\s*(km|โล|k)$/i
        my_dist = $1.to_f
        return dist_update(my_dist)
      when /^map/i
        return show_map
      when /^plan text/i
        show_plan_text
        return true
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
        sender_name = @sender_name
      else
        sender_name = 'คุณหมายเลข'+bib
      end

      course = Course.where(title: course_name).first
      unless course
        @message[:text] = "#{sender_name} ผมไม่รู้จักงาน #{course_name}"
        return true
      end

      runner = Athlete.find_or_create_by(line_id: @event['source']['userId'])
      runner.line_name = sender_name
      runner.save
      run = Run.find_or_create_by(athlete: runner,course: course)
      run.bib = bib
      run.save
      @message[:text] = "OK พี่ #{sender_name} จะวิ่งงาน #{course.title} ระยะ #{course.distance}km ด้วยหมายเลข #{bib} #{encourage_text}"

      #add user to group, if this is group message
      if @event['source']['type'] == 'group'
        LineGroup.find_or_create_by(line_group_id: @event['source']['groupId'], line_id: @event['source']['userId'], race_id: RACE_ID)
      else
        LineGroup.find_or_create_by(line_group_id: @event['source']['userId'], line_id: @event['source']['userId'], race_id: RACE_ID)
      end

      #set plans
      run.plans.destroy_all
      if target
        @message[:text] += "\n\nแผน #{target} ชั่วโมง\n(กราบขอบพระคุณข้อมูลจาก Chilling Trail)\n#{PLAN_URL}"
        run.plan_hour = target
        run.save
        chilling_trail_update_plan(runner,course,target)
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

    def add_bib_to_group(bib,group_id)
      run = Run.joins(course: :race).where("race_id = ?",RACE_ID).where(bib: bib).first

      unless run
        #@message[:text] = "bib #{bib} ยังไม่ได้ลงทะเบียนครับ ขอให้คนนั้นลงทะเบียนก่อน โดยทำงี้ครับ\n\n 1. add ผมเป็นเพื่อน \n\n 2. พิมพ์ \"ลงทะเบียน pytxxx bib yyyy แผน zz\" เช่น \n\nลงทะเบียน pyt166 bib 6124 แผน 36 \n\nเพื่อบอกผมว่า จะวิ่งงานไหน บิบอะไร ด้วยแผนกี่ ชม." 
        #return true

	if bib.to_i < 999
          course = Course.where(title: 'PYT166',race: RACE_ID).first
	elsif bib[0] == '9'
          course = Course.where(title: 'PYT120',race: RACE_ID).first
	elsif bib[0] == '8'
          course = Course.where(title: 'PYT100',race: RACE_ID).first
	elsif bib[0] == '7'
          course = Course.where(title: 'PYT70',race: RACE_ID).first
	elsif bib[0] == '5'
          course = Course.where(title: 'NPT50',race: RACE_ID).first
	elsif bib[0] == '3'
          course = Course.where(title: 'PNK30',race: RACE_ID).first
	elsif bib[0] == '1'
          course = Course.where(title: 'WFL15',race: RACE_ID).first
	end
        unless course
          @message[:text] = "#{sender_name} ผมไม่รู้จักงาน #{course_name}"
          return true
        end
        runner = Athlete.new
        runner.line_name = bib
        runner.save
        run = Run.find_or_create_by(athlete: runner,course: course)
        run.bib = bib
        run.save
      end

      #add user to group, if this is group message
      LineGroup.find_or_create_by(line_group_id: group_id, line_id: run.athlete.line_id, race_id: RACE_ID)
      @message[:text] = "รับทราบ เพิ่ม บิบหมายเลข #{run.bib} ลงงาน #{run.course.title} เรียบร้อย\n\n (ดูผลโดยพิมพ์ progress pyt)"
      return true
    end

    def show_map
      if client_is_friend?
        runner = Athlete.find_or_create_by(line_id: @event['source']['userId'])

        return true unless registered?

        Run.where(athlete: runner).each do |run|
            @message[:type] = "image"
            @message[:originalContentUrl] = "https://line.nattee.net/pyt-2019/#{run.course.title}_map.jpg"
            @message[:previewImageUrl] = "https://line.nattee.net/pyt-2019/#{run.course.title}_map_preview.jpg"
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
            @message[:text] = "ไม่ได้ระบุแผนไว้ ช่วยระบุแผนด้วยคำสั่ง \"ลงทะเบียน #{run.course.title} bib #{run.bib} แผน XX\" โดยให้ X ระบุจำนวนชั่วโมงที่ต้องใช้ \n\n(กราบขอบพระคุณข้อมูลจาก Chilling Trail)\n#{PLAN_URL}"
            return true
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
            @message[:text] = "ไม่ได้ระบุแผนไว้ ช่วยระบุแผนด้วยคำสั่ง \"ลงทะเบียน #{run.course.title} bib #{run.bib} แผน XX\" โดยให้ X ระบุจำนวนชั่วโมงที่ต้องใช้ \n\n(กราบขอบพระคุณข้อมูลจาก Chilling Trail)\n#{PLAN_URL}"
            return
          end

          #show plan image
          @message = Array.new
          @message << {
            type: "image",
            originalContentUrl: "https://line.nattee.net/pyt-2019/PLAN-#{run.course.title}-#{sprintf("%.02f",run.plan_hour)}.jpg",
            previewImageUrl: "https://line.nattee.net/pyt-2019/preview-PLAN-#{run.course.title}-#{sprintf("%.02f",run.plan_hour)}.jpg",
          }
          @message << {
            type: 'text',
            text: "(กราบขอบพระคุณข้อมูลจาก Chilling Trail)\n#{PLAN_URL}",
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
      Course.where(race_id: RACE_ID).all.each.with_index do |course,i|
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
        if station.distance <= dist
          station_code = station.code
          next
        end

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
          break
        end
      end

      #run.station = station_code
      #run.current_dist = dist
      run.save

      if next_cutoff
        #calculate
        d = cutoff_dist - dist
        t = remaining_time_in_minutes(next_cutoff)
        d_text = sprintf("%.2f",d)
        pace = t/d


        #response
        cutoff_text = <<~EOS
        cutoff ต่อไปที่ #{cutoff_station} 
        ตอน #{next_cutoff.strftime("%H:%M ของวันที่ %-d")}
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

    def progress_text(group_id,options = {})
      resp = ""
      resp = "ข้อมูล check in ล่าสุดจาก Chilling Trail\n" if options[:official]
      Course.where(race_id: RACE_ID).all.each.with_index do |course,i|
        has_runner = false
        last_station = 'hahaha'
        sort_string = (options[:official] ? 'ct_distance, ct_checkin_time DESC' : 'current_dist, ct_checkin_time DESC')
        Run.joins(:athlete).joins("INNER JOIN line_groups ON athletes.line_id = line_groups.line_id").
          where("line_groups.line_group_id = ?",group_id).
          where(course: course).
          order(sort_string).uniq.each.with_index do |run,j|

          #display course name
          resp += "*" + course.title + "*" if j == 0

          #display station name
          if (options[:official] == true)
            resp += "\n" if j == 0
            resp += "_#{run.athlete.proper_name}:_ #{run.chilling_trail_status}\n"
          else
            if last_station != run.station
              last_station = run.station
              if last_station.nil? || last_station.empty?
                resp += "\nยังไม่เริ่ม:\n"
              else
                resp += "\nผ่าน #{last_station} แล้ว:\n"
              end
            end

            resp += "#{run.athlete.proper_name} (#{sprintf("%.1f",run.current_dist || 0)}km)\n"
          end
          has_runner = true
        end
        resp += "\n" if has_runner
      end

      resp += 'กราบขอบพระคุณข้อมูลจาก Chilling Trail (https://www.facebook.com/Chilling.Trail/)'
      @message[:text] = resp
      return true
    end

    def call_chilling_trail_all_runner(group_id)
      Run.joins(:athlete).joins("INNER JOIN line_groups ON athletes.line_id = line_groups.line_id").
        where("line_groups.line_group_id = ?",group_id).uniq.each.with_index do |run,j|

        chilling_trail_update(run.bib)
      end
      #Course.where(race_id: RACE_ID).all.each.with_index do |course,i|
      #  Run.where(course: course).order('current_dist').each.with_index do |run,j|
      #    chilling_trail_update(run.bib)
      #  end
      #end
    end

    def chilling_trail_update(bib)
      #find the ahtlete
      run = Run.where(bib: bib).first

      #quit if this bib was updated in the last 60 secs.
      return nil unless run && (run.last_online_call_timestamp.nil? || run.last_online_call_timestamp < 60.second.ago)

      begin
	url = "#{RACE_URL}/#{bib}"
	#puts url
        response = RestClient.get(url)
        hash = JSON.parse(response)

        #if bib not found
        return nil unless hash

        #update
        run.last_online_call_timestamp = Time.zone.now

        begin
          run.status = hash['progress']['state']
          run.start_time = hash['progress']['startTime']
          run.ct_station = hash['progress']['station']
          run.ct_checkin_time = hash['progress']['time']
          run.ct_distance = hash['progress']['distance']
          if (run.current_dist.nil? || run.current_dist < hash['progress']['distance'] || hash['progress']['state'] == 'DNF')
            run.current_dist = hash['progress']['distance']
            run.update_station(hash['progress']['distance'])
          end
        end

        run.save
      rescue RestClient::ExceptionWithResponse => e
        return nil
      end
    end

    def chilling_trail_update_plan(athlete,course,target)
      begin
	url = "#{PLAN_URL}&distance=#{course.distance.to_i}&target=#{target}&output=json"
        #puts url
        response = RestClient.get(url)
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
	pic_response = RestClient.get("#{PLAN_URL}&distance=#{course.distance.to_i}&target=#{target}")
        if pic_response.code == 200
          dir = Rails.root.join('public','pyt-2019')
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


    def registered?(line_id = @event['source']['userId'], sender = @sender_name)
      runner = Athlete.where(line_id: line_id).first
      help_text = "#{sender} ยังไม่ได้ลงทะเบียนครับ ช่วยลงทะเบียนก่อนโดยพิมพ์ \"ลงทะเบียน CMx bib yyyy แผน zz\" เช่น ลงทะเบียน PYT bib 4124 แผน 36 เพิ้อบอกผมว่า จะวิ่งงานไหน บิบอะไร ด้วยแผนกี่ ชม." 
      unless runner
        @message[:text] = help_text
        return false
      end
      run = Run.where(athlete: runner).first
      unless run
        @message[:text] = help_text
        return false
      end
      return true
    end

  end #class
end

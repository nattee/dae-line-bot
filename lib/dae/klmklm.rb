require 'rest-client'
require 'json'

module Dae
  class KLMKLM
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
      when /^([0-9][0-9][0-9])$/i
        res = DirectResponse.where(text: $1).first
        if res
          resp = res.response
          @message[:text] = "น้อง #{$1} ฝากดูแล #{resp} ครับ!!!"
          return true
	else
          @message[:text] = "ห้อง #{$1} มีที่ไหนครับ! สัส! กวนตรีนได้ แต่แยกขยะด้วยนะครับ!!! "
	  return true
        end
        return false
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
      when /^ควย/
        @message[:text] = 'หยาบคายได้ครับ แต่แยกขยะด้วยนะครับ!!! ขอบควยมาก ๆ ครับ!!!'
        return true
      when /^ครวย/
        @message[:text] = 'หยาบคายได้ครับ แต่แยกขยะด้วยนะครับ!!! ขอบครวยมาก ๆ ครับ!!!'
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

  end #class
end

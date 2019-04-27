class ApiController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :setup_client

  require 'line/bot'

  def test
  end

  def get_callback
    render plain: "OK", content_type: 'text/plain'
  end

  def callback
    body = request.body.read

    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless @client.validate_signature(body, signature)
      render plain: "Bad Request", content_type: 'text/plain', status: 400
      return
    end

    events = @client.parse_events_from(body)
    events.each { |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          user_text = event.message['text']
          running = Dae::Running.new
          result = running.process_text(user_text)
          if result
            profile_resp = @client.get_profile(event['source']['userId'])
            hash = JSON.parse profile_resp.body
            user_name = hash['displayName'] || 'ไม่ได้แอดผมเป็นเพื่อน ผมเลยไม่รู้จักชื่อคุณ'

            #if user does not befriend the bot, hash['displayName'] will be nil (and make everyting failed... returning nil)
            reply_text = user_name+"\n"+result
          else
            reply_text = 'ไม่รู้เรื่อง'
          end
          #build reply
          message = {
            type: 'text',
            text: reply_text
          }
          @client.reply_message(event['replyToken'], message) if result
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          response = @client.get_message_content(event.message['id'])
          tf = Tempfile.open("content")
          tf.write(response.body)
        end
      end
    }

    render plain: "OK", content_type: 'text/plain'
  end

  private
  def setup_client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = Rails.application.secrets.LINE_CHANNEL_SECRET
      config.channel_token = Rails.application.secrets.LINE_CHANNEL_TOKEN
    }
  end
end

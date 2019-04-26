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
          message = {
            type: 'text',
            text: event.message['text']
          }
          @client.reply_message(event['replyToken'], message)
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

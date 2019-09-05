class ApiController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :setup_client

  require 'line/bot'

  def test
  end

  def get_callback
    render plain: "OK", content_type: 'text/plain'
  end

  #this is my default callback
  def callback
    body = request.body.read

    #validate signature
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless @client.validate_signature(body, signature)
      render plain: "Bad Request", content_type: 'text/plain', status: 400
      return
    end

    #parse event
    events = @client.parse_events_from(body)
    events.each { |event|
      case event

      #process Message event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          #Dae::Running.new.respond_to(event,@client)
          #Dae::RunningCM62019.new.respond_to(event,@client)
          Dae::KLMKLM.new.respond_to(event,@client)
        when Line::Bot::Event::MessageType::Image, Line::Bot::Event::MessageType::Video
          #response = @client.get_message_content(event.message['id'])
          #f = Tempfile.open("content")
          #f.write(response.body)
        end
      else
        #for other event type (follow, join, beacon, etc.. we won't do anything
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

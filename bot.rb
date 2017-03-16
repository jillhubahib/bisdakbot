require 'facebook/messenger'
require 'addressable/uri'
require 'httparty'
require 'json'
require 'securerandom'
require_relative 'constants'
require_relative 'menu'
require_relative 'greetings'
include Facebook::Messenger

Facebook::Messenger::Subscriptions.subscribe(access_token: ENV['ACCESS_TOKEN'])
Menu.enable
Greetings.enable

Bot.on :postback do |postback|
  sender_id = postback.sender['id']
  case postback.payload
  when 'START'
    say(sender_id, IDIOMS[:menu_greeting])
  when 'HUGOTLINE'
    say(sender_id, hugot_line)
  when 'ASAKO'
    lookup_location(sender_id)
  end
end

def wait_for_command
  Bot.on :message do |message|
    puts "Received '#{message.inspect}' from #{message.sender}"
    sender_id = message.sender['id']
    case message.text
    when /hugot/i, /pickup/i
      say(sender_id, hugot_line)
    when /asa ko/i, /asako/i
      lookup_location(sender_id)
    when /help/i, /tabang/i
      say(sender_id, HELP_TEXT)
    else
      say(sender_id, IDIOMS[:unknown_command])
    end
  end
end

def wait_for_any_input
  Bot.on :message do |message|
    puts "Received '#{message.inspect}' from #{message.sender}" # debug only
    wait_for_command
  end
end

def say(recipient_id, text, quick_replies = nil)
  message_options = {
    recipient: { id: recipient_id },
    message: { text: text }
  }
  message_options[:message][:quick_replies] = quick_replies if quick_replies

  Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
end

def hugot_line
  max = HUGOT_LINES.length
  HUGOT_LINES[SecureRandom.random_number(max)]
end

def lookup_location(sender_id)
  say(sender_id, 'Okay, tabangi kog locate nimo:', TYPE_LOCATION)
  Bot.on :message do |message|
    if message_contains_location?(message)
      handle_user_location(message)
    else
      message.reply(text: "Pasensya di ko kalocate, palihug ug usab...")
      lookup_location(sender_id)
    end
    wait_for_any_input
  end
end

def message_contains_location?(message)
  if attachments = message.attachments
    attachments.first['type'] == 'location'
  else
    false
  end
end

def handle_user_location(message)
  coords = message.attachments.first['payload']['coordinates']
  lat = coords['lat']
  long = coords['long']
  message.type
  # make sure there is no space between lat and lng
  parsed = get_parsed_response(REVERSE_API_URL, "#{lat},#{long}")
  address = extract_full_address(parsed)
  message.reply(text: "Coordinates kung asa ka: Latitude #{lat}, Longitude #{long}. Murag naa ka sa #{address}")
  wait_for_any_input
end

def get_parsed_response(url, query)
  response = HTTParty.get(url + query)
  parsed = JSON.parse(response.body)
  parsed['status'] != 'ZERO_RESULTS' ? parsed : nil
end

def extract_full_address(parsed)
  parsed['results'].first['formatted_address']
end

wait_for_any_input

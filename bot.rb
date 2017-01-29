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
  when 'START' then show_replies_menu(postback.sender['id'], MENU_REPLIES)
  when 'HUGOTLINE'
    say(sender_id, get_hugot_line)
  end
end

def show_replies_menu(id, quick_replies)
  say(id, IDIOMS[:menu_greeting], quick_replies)
  wait_for_command
end

def wait_for_command
  Bot.on :message do |message|
    puts "Received '#{message.inspect}' from #{message.sender}"
    sender_id = message.sender['id']
    case message.text
    when /hugot/i, /pickup/i
      say(sender_id, get_hugot_line)
    when /help/i, /tabang/i
      say(sender_id, HELP_TEXT)
    else
      say(sender_id, IDIOMS[:unknown_command])
      say(sender_id, HELP_TEXT)
    end
  end
end

def wait_for_any_input
  Bot.on :message do |message|
    puts "Received '#{message.inspect}' from #{message.sender}" # debug only
    show_replies_menu(message.sender['id'], MENU_REPLIES)
  end
end

def say(recipient_id, text, quick_replies = nil)
  message_options = {
    recipient: { id: recipient_id },
    message: { text: text }
  }
  if quick_replies
    message_options[:message][:quick_replies] = quick_replies
  end
  Bot.deliver(message_options, access_token: ENV['ACCESS_TOKEN'])
end

def get_hugot_line
  max = HUGOT_LINES.length
  HUGOT_LINES[SecureRandom.random_number(max)]
end

wait_for_any_input

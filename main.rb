#!/usr/bin/env ruby
require 'watir'

def log (message)
  puts "#{message}"
end

def notify (message)
  log message.upcase
  system 'osascript -e \'Display notification with title "%s"\'' % message
rescue StandardError => e
end

def changes? (b)
  url = 'https://doodle.com/poll/9tvdktysbrps8p9z'

  puts '-' * 80
  log 'Trying again'
  b.goto url
  log 'Page has loaded'

  selector = '#d-pollView article div div div ul li:nth-child(1) label div.d-optionDetails div button.d-button.d-countButton.d-medium.d-silentButton div div.d-buttonContent div.d-textContainer div'

  tag = b.element css: selector

  participants = tag.text

  if participants != '32/32'
    notify 'A slot is available!'

    log 'Enter y to continue or anything else to quit.'
    return gets.chomp.downcase != 'y'
  else
    log 'No luck this time.'
    return false
  end
rescue StandardError => e
  log "Error encountered: #{e.inspect}"
  return false
end

b = Watir::Browser.new :chrome
until changes? b
  log 'Sleeping...'
  sleep 60
end
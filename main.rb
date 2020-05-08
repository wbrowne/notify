#!/usr/bin/env ruby
require 'watir'
require 'thor'

def notify (message)
  say message
  system 'osascript -e \'Display notification with title "%s"\'' % message
rescue StandardError => e
end

def changes? (b, url)
  b.goto url

  selector = '#d-pollView article div div div ul li:nth-child(1) label div.d-optionDetails div button.d-button.d-countButton.d-medium.d-silentButton div div.d-buttonContent div.d-textContainer div'
  tag = b.element css: selector
  participants = tag.text

  if participants != '32/32'
    say 'A slot is available!', :green

    input = ask 'Should I continue to watch? (y/n) ', :blue, default: 'n'
    return input.downcase != 'y'
  else
    return false
  end
rescue StandardError => e
  say "Error encountered: #{e.inspect}", :red
  return false
end

class MyCLI < Thor
  desc "watch URL", "URL to watch"
  def watch(url)
    b = Watir::Browser.new :chrome
    until changes? b, url
      say 'Sleeping...'
      sleep 60
    end
  end
end
# ruby ./main.rb watch https://doodle.com/poll/9tvdktysbrps8p9z

MyCLI.start(ARGV)
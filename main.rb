#!/usr/bin/env ruby
require 'watir'
require 'thor'
require 'json'

Watir.default_timeout = 15

def notify (message)
  say message
  system 'say bingaling && osascript -e \'Display notification with title "%s"\'' % message
rescue StandardError => e
end

def changes? (browser, data)
  url = data['url']
  selector = data['criteria']['js_selector']
  match = data['criteria']['match']

  browser.goto url
  element = browser.element css: selector

  unless element.present?
    say "Could not find element via selector (hidden=#{element.hidden?})", :red

    return false
  end

  if element.text != match
    notify 'Matched!'
    input = ask 'Should I continue to watch? (y/n) ', :blue, default: 'n'

    return input.downcase != 'y'
  end
  false

rescue Watir::Exception::UnknownObjectException => e
  say "Could not find element: #{e.inspect}", :red
rescue StandardError => e
  say "Error occurred: #{e.inspect}", :red
  return false
end

def read_file(file_path)
  file = File.open file_path

  JSON.load file
end

class MyCLI < Thor
  def self.exit_on_failure?
    true
  end

  desc "watcher <data.json>", "setup watcher using JSON file that defines watch parameters"
  def watch(file_path)
    data = read_file file_path

    b = Watir::Browser.new :chrome

    # wait and poll for changes
    until changes? b, data
      say 'Sleeping...'
      sleep data['interval']
    end
  end
end

MyCLI.start(ARGV)
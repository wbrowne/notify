#!/usr/bin/env ruby
require 'watir'
require 'thor'
require 'json'
require 'mail'

Watir.default_timeout = 15

def notify (message, notificationSettings)
  say message
  system 'say bingaling && osascript -e \'Display notification with title "%s"\'' % message

  send_email notificationSettings

rescue StandardError => e
end

def send_email(notificationSettings)
  serverSettings = notificationSettings['server']

  Mail.defaults do
    delivery_method :smtp, {
        address: serverSettings['address'],
        port: serverSettings['port'],
        domain: serverSettings['domain'],
        user_name: serverSettings['username'],
        password: serverSettings['password'], #ENV.fetch('EMAIL_PASSWORD'),
        authentication: :login,
        enable_starttls_auto: true
    }
  end

  mail = Mail.new do
    to notificationSettings['to']
    from notificationSettings['from']
    subject 'Test'
    body 'Test'
  end

  mail.deliver
end

def changes? (browser, config)
  url = config['url']
  selector = config['criteria']['js_selector']
  matchCriteria = config['criteria']['match']

  browser.goto url
  element = browser.element css: selector

  unless element.present?
    say "Could not find element via selector (hidden=#{element.hidden?})", :red

    return false
  end

  if is_a_match? matchCriteria, element
    notify 'Matched!', config['notification']
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

def is_a_match? (match, element)
  if match['condition'] == 'ne'
    return match['text'] != element.text
  end

  return match['text'] == element.text
end

def read_file(file_path)
  file = File.open file_path

  JSON.load file
end

class MyCLI < Thor
  def self.exit_on_failure?
    true
  end

  desc "watch <config.json>", "setup watcher using JSON file that defines watch config"

  def watch(file_path = "config.json")
    config = read_file file_path

    b = Watir::Browser.new :chrome

    # wait and poll for changes
    until changes? b, config
      say 'Sleeping...'
      sleep config['interval']
    end
  end
end

MyCLI.start(ARGV)
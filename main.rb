#!/usr/bin/env ruby
require 'watir'
require 'thor'
require 'json'
require 'mail'

Watir.default_timeout = 15

def notify (message, notification_config)
  say message
  system 'say bingaling'
  send_macos_notification "Notify - Match Found!", notification_config['name']

  send_email notification_config

rescue StandardError => e
end

def send_macos_notification (title, message)
  system "osascript -e 'Display notification \"#{message}\" with title \"#{title}\"'"
end

def send_email(notification_config)
  server_config = notification_config['server']

  Mail.defaults do
    delivery_method :smtp, {
        address: server_config['address'],
        port: server_config['port'],
        domain: server_config['domain'],
        user_name: server_config['username'],
        password: server_config['password'],
        authentication: :login,
        enable_starttls_auto: true
    }
  end

  mail = Mail.new do
    to notification_config['to']
    from notification_config['from']
    subject "Notify - Match Found for watcher \"#{notification_config['name']}\""
    body "Go check it out #{notification_config['redirect']}"
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

    return true
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

def read_json_file(file_path)
  file = File.open file_path

  JSON.load file
end

class MyCLI < Thor
  def self.exit_on_failure?
    true
  end

  desc "watch <config.json>", "setup watcher using JSON file that defines watch config"

  def watch(file_path = "config.json")
    config = read_json_file file_path

    b = Watir::Browser.new :chrome

    # wait and poll for changes
    until changes? b, config
      say 'Sleeping...'
      sleep config['interval']
    end
  end
end

MyCLI.start(ARGV)
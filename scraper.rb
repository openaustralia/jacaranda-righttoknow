# This is a template for a Ruby scraper on morph.io (https://morph.io)
# including some code snippets below that you should find helpful

require 'scraperwiki'
require 'mechanize'
require 'rest-client'
require 'json'
require "active_support/all"

def post_message_to_slack(text)
  request_body = {
    username: "Jacaranda",
    text: text
  }

  request_body.merge!(channel: "#bottesting") unless ENV["MORPH_LIVE_MODE"].eql? "true"

  RestClient.post(ENV["MORPH_SLACK_CHANNEL_WEBHOOK_URL"], request_body.to_json)
end

def extract_value_from_page(page)
  page.at(".foi_results").text.split.last
end

def get_count_for_right_to_know_query_between(query, start_date, end_date)
  base_url = "https://www.righttoknow.org.au/search/#{query}%20#{start_date.strftime("%D")}..#{end_date.strftime("%D")}.html?"
  page = Mechanize.new.get(base_url + "page=2")
  # TODO: remove the if logic and just get the results,
  #       once https://github.com/openaustralia/righttoknow/issues/673 is fixed.
  if page.at(".foi_results")
    extract_value_from_page(page)
  else
    page = Mechanize.new.get(base_url + "page=1")
    extract_value_from_page(page)
  end
end

beginning_of_fortnight = 1.fortnight.ago.beginning_of_week.to_date
end_of_fortnight = 1.week.ago.end_of_week.to_date
last_fortnight = (beginning_of_fortnight..end_of_fortnight).to_a

# if it's been a fortnight since the last message post a new one
if ENV["MORPH_LIVE_MODE"].eql? "true"
  puts "In live mode, this will post to Slack and save to the db"
else
  puts "In test mode, this wont post to Slack or save to the db"
end

puts "Check if it has collected data in the last fortnight"
if (ScraperWiki.select("* from data where `date_posted`>'#{1.fortnight.ago.to_date.to_s}'").empty? rescue true)
  puts "Collect new requests information from Right To Know"
  new_requests_last_fortnight = get_count_for_right_to_know_query_between("variety:sent", last_fortnight.first, last_fortnight.last)
  annotations_last_fortnight = get_count_for_right_to_know_query_between("variety:comment", last_fortnight.first, last_fortnight.last)
  successes_last_fortnight = get_count_for_right_to_know_query_between("status:successful", last_fortnight.first, last_fortnight.last)

  # build the sentence with new sign up stats
  text = new_requests_last_fortnight.to_s +
        " new requests were made through Right To Know last fortnight :saxophone:\n"
  text += "Our contributors helped people with #{annotations_last_fortnight} annotations :heartbeat:\n"
  text += "#{successes_last_fortnight} requests were marked successful! :trophy:"

  puts "Post the message to Slack"
  if ENV["MORPH_LIVE_MODE"].eql? "true"
    if post_message_to_slack(text) === "ok"
      # record the message and the date sent to the db
      puts "Save the message to the db"
      ScraperWiki.save_sqlite([:date_posted], {date_posted: Date.today.to_s, text: text})
    end
  else
    puts text
  end
else
  p "I’ve already spoken to the team this fortnight"
end

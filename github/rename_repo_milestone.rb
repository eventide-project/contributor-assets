#!/usr/bin/env ruby

require 'json'
require 'net/http'
require 'erb'

module Defaults
  extend self

  def uri
    URI("https://api.github.com/repos/#{org_name}/#{repo}/milestones")
  end

  def dry_run
    ENV.fetch('DRY_RUN', 'off')
  end

  def dry_run?
    dry_run == 'on'
  end

  def original_milestone_name
    ENV.fetch('ORIGINAL_MILESTONE') do
      'v3'
    end
  end

  def milestone_name
    ENV.fetch('MILESTONE') do
      'Gen 3'
    end
  end

  def repo
    ENV.fetch('REPO') do
      abort "Usage: #{$PROGRAM_NAME} repo"
    end
  end

  def org_name
    ENV.fetch('ORG_NAME', 'eventide-project')
  end

  def github_token
    ENV.fetch('GITHUB_TOKEN') do
      abort "GITHUB_TOKEN isn't set"
    end
  end
end
extend Defaults

class Reconcile
  include Defaults

  attr_reader :http
  attr_reader :uri

  def initialize(http, uri)
    @http = http
    @uri = uri
  end

  def self.call(...)
    instance = new(...)
    instance.()
  end

  def call
    request = Net::HTTP::Get.new(milestones_uri)
    milestones = http_request(request) do |response|
      json_data = response.body
      JSON.parse(json_data, symbolize_names: true)
    end

    milestone = milestones.find do |milestone|
      milestone[:title] == milestone_name
    end

    if not milestone.nil?
      puts "Already renamed #{original_milestone_name.inspect} to #{milestone_name.inspect}"
      return
    end

    original_milestone = milestones.find do |milestone|
      milestone[:title] == original_milestone_name
    end

    if not original_milestone.nil?
      milestone_number = original_milestone.fetch(:number)
      milestone_uri = milestone_uri(milestone_number)
      request = Net::HTTP::Patch.new(milestone_uri)
      data = { title: milestone_name }
    else
      request = Net::HTTP::Post.new(milestones_uri)
      data = { title: milestone_name, state: 'open' }
    end

    json = JSON.generate(data)
    request.body = json

    http_request(request)
  end

  def http_request(request, &response_action)
    request.basic_auth(github_token, 'x-oauth-basic')
    request['Accept'] = 'application/vnd.github.v3+json'

    puts "#{request.method} #{request.uri}"

    request_body = request.body.to_s
    if not request_body.empty?
      puts request_body
    end

    if request.is_a?(Net::HTTP::Get)
      dry_run = false
    else
      dry_run = self.dry_run?
    end

    if not dry_run
      return_value = nil

      http.request(request) do |response|
        if not Net::HTTPSuccess === response
          abort "Server response: #{response.inspect}"
        end

        puts "#{response.code} #{response.message}"

        if not response_action.nil?
          return_value = response_action.(response)
        end
      end
    else
      puts "(Dry run, no response)"
    end

    puts

    return_value
  end

  def milestones_uri
    uri
  end

  def milestone_uri(milestone_number)
    URI("#{self.uri}/#{milestone_number}")
  end
end

puts <<~TEXT
Rename Milestone #{original_milestone_name.inspect} -> #{milestone_name.inspect} for #{repo}
- - -

TEXT

use_ssl = uri.scheme == 'https'
Net::HTTP.start(uri.hostname, use_ssl:) do |http|
  Reconcile.(http, uri)
end

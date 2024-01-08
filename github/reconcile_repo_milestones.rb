#!/usr/bin/env ruby

require 'json'
require 'net/http'

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

  def org_milestones
    @org_milestones ||= get_org_milestones
  end

  def get_org_milestones
    milestones_text = ENV.fetch('MILESTONES') do
      abort "MILESTONES isn't set"
    end

    milestones_text.each_line.map do |json|
      JSON.parse(json, symbolize_names: true)
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

Milestone = Struct.new(:github_number, :correct_title, :title, :correct_description, :description, :correct_state, :state) do
  def extant?
    !github_number.nil?
  end

  def hash
    correct_title.hash
  end

  def self.org_milestone(milestone_data)
    correct_title = milestone_data.fetch(:title)
    correct_description = milestone_data.fetch(:description)
    correct_state = milestone_data.fetch(:state)

    new(correct_title:, correct_description:, correct_state:)
  end

  def self.repo_milestone(milestone_data)
    title = milestone_data.fetch(:title)
    github_number = milestone_data.fetch(:number)
    description = milestone_data.fetch(:description)
    state = milestone_data.fetch(:state)

    correct_title = canonize_title(title)

    milestone = new(correct_title:)
    milestone.repo_milestone_data(title, github_number, description, state)
    milestone
  end

  def self.canonize_title(title)
    title_pattern = /^(?:Gen |v)(?<number>[[:digit:]]+)(?<suffix>\+?)$/

    match_data = title_pattern.match(title)

    if match_data.nil?
      abort "Incorrect title #{title.inspect}"
    end

    number = match_data[:number]
    suffix = match_data[:suffix]

    "Gen #{number}#{suffix}"
  end

  def repo_milestone_data(title, github_number, description, state)
    self.title = title
    self.github_number = github_number
    self.description = description
    self.state = state
  end

  def missing?
    !extant?
  end

  def obsolete?
    return false if missing?

    correct_title.nil? && correct_description.nil? && correct_state.nil?
  end

  def divergent?
    return false if missing?
    return false if obsolete?

    title != correct_title || description != correct_description || state != correct_state
  end

  def current?
    return false if missing?
    return false if obsolete?
    return false if divergent?

    true
  end

  def data
    data = {}

    if title != correct_title
      data[:title] = correct_title
    end

    if description != correct_description
      data[:description] = correct_description
    end

    if state != correct_state
      data[:state] = correct_state
    end

    data
  end
end

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
    org_milestones.each do |milestone_data|
      milestone = Milestone.org_milestone(milestone_data)

      milestones << milestone
    end

    get_request = Net::HTTP::Get.new(uri)
    repo_milestones = http_request(get_request) do |get_response|
      json_data = get_response.body
      JSON.parse(json_data, symbolize_names: true)
    end

    repo_milestones.each do |milestone_data|
      title = milestone_data.fetch(:title)

      milestone = get_milestone(title)

      if not milestone.nil?
        github_number = milestone_data.fetch(:number)
        description = milestone_data.fetch(:description)
        state = milestone_data.fetch(:state)

        milestone.repo_milestone_data(title, github_number, description, state)
      else
        milestone = Milestone.repo_milestone(milestone_data)

        milestones << milestone
      end
    end

    milestones.each do |milestone|
      if milestone.current?
        next
      elsif milestone.missing?
        request = Net::HTTP::Post.new(uri)

        data = milestone.data
      else
        github_number = milestone.github_number
        milestone_uri = milestone_uri(github_number)

        if milestone.obsolete?
          request = Net::HTTP::Delete.new(milestone_uri)
        else
          request = Net::HTTP::Patch.new(milestone_uri)
          data = milestone.data
        end
      end

      if not data.nil?
        json = JSON.generate(data)
        request.body = json
      end

      http_request(request)
    end
  end

  def milestone_uri(github_number)
    URI("#{self.uri}/#{github_number}")
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

  def get_milestone(title)
    correct_title = Milestone.canonize_title(title)

    milestones.find do |milestone|
      milestone.correct_title == correct_title
    end
  end

  def milestones
    @milestones ||= Set.new
  end
end

puts <<~TEXT
Reconcile Milestones for #{repo}
- - -

TEXT

use_ssl = uri.scheme == 'https'
Net::HTTP.start(uri.hostname, use_ssl:) do |http|
  Reconcile.(http, uri)
end

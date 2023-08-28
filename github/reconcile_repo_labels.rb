#!/usr/bin/env ruby

require 'json'
require 'net/http'
require 'erb'

module Defaults
  extend self

  def uri
    URI("https://api.github.com/repos/#{org_name}/#{repo}/labels")
  end

  def dry_run
    ENV.fetch('DRY_RUN', 'off')
  end

  def dry_run?
    dry_run == 'on'
  end

  def org_labels
    @org_labels ||= get_org_labels
  end

  def get_org_labels
    labels_text = ENV.fetch('LABELS') do
      abort "LABELS isn't set"
    end

    labels_text.each_line.map do |json|
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

Label = Struct.new(:name, :color, :description, :correct_color, :correct_description, :extant) do
  alias :extant? :extant

  def self.org_label(label_data)
    name = label_data.fetch(:name)
    correct_color = label_data.fetch(:color)
    correct_description = label_data.fetch(:description)
    extant = false

    new(name:, correct_color:, correct_description:, extant:)
  end

  def self.repo_label(label_data)
    name = label_data.fetch(:name)
    color = label_data.fetch(:color)
    description = label_data.fetch(:description)

    label = new(name:)
    label.repo_label_data(color, description)
    label
  end

  def repo_label_data(color, description)
    self.color = color
    self.description = description
    self.extant = true
  end

  def missing?
    !extant?
  end

  def obsolete?
    return false if missing?

    correct_color.nil? && correct_description.nil?
  end

  def divergent?
    return false if missing?
    return false if obsolete?

    color != correct_color || description != correct_description
  end

  def current?
    return false if missing?
    return false if obsolete?
    return false if divergent?

    true
  end

  def patch_data
    data = {}

    if color != correct_color
      data[:color] = correct_color
    end

    if description != correct_description
      data[:description] = correct_description
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
    org_labels.each do |label_data|
      label = Label.org_label(label_data)

      labels[label.name] = label
    end

    get_request = Net::HTTP::Get.new(uri)
    repo_labels = http_request(get_request) do |get_response|
      json_data = get_response.body
      JSON.parse(json_data, symbolize_names: true)
    end

    repo_labels.each do |label_data|
      name = label_data.fetch(:name)

      label = labels[name]

      if not label.nil?
        color = label_data.fetch(:color)
        description = label_data.fetch(:description)
        label.repo_label_data(color, description)
      else
        label = Label.repo_label(label_data)
        labels[name] = label
      end
    end

    labels.each do |name, label|
      if label.current?
        next
      elsif label.missing?
        request = Net::HTTP::Post.new(uri)
        data = { name:, color: label.correct_color, description: label.correct_description }
      else
        label_uri = label_uri(name)

        if label.obsolete?
          request = Net::HTTP::Delete.new(label_uri)
        else
          request = Net::HTTP::Patch.new(label_uri)
          data = label.patch_data
        end
      end

      if not data.nil?
        json = JSON.generate(data)
        request.body = json
      end

      http_request(request)
    end
  end

  def label_uri(name)
    url_encoded_name = ERB::Util.url_encode(name)

    URI("#{self.uri}/#{url_encoded_name}")
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

  def labels
    @labels ||= {}
  end
end

puts <<~TEXT
Reconcile Labels for #{repo}
- - -

TEXT

use_ssl = uri.scheme == 'https'
Net::HTTP.start(uri.hostname, use_ssl:) do |http|
  Reconcile.(http, uri)
end

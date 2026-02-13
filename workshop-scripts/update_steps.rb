#!/usr/bin/env ruby
#
# Usage
#
# This script is intended to be run after the commit histories in
# account-component and funds-transfer-component have been corrected and pushed
# to the git origin. It must be run in the top level workshop directory.
#
# After running the script, the step scripts in the workshop project are
# altered to reference the new commits. Do not change the commit messages, as
# this script will use the commit messages to look up the commit SHAs.
#

class Parse
  attr_reader :text

  def result
    @result ||= Result.new
  end

  def initialize(text)
    @text = text
  end

  def self.call(file)
    text = File.read(file)

    instance = new text
    instance.()
  end

  def call
    commit_match_data = commit_pattern.match(text)

    reference = commit_match_data[:reference]

    project = commit_match_data[:project]

    unless reference == "master"
      message_match_data = message_pattern.match(text)

      message = message_match_data[:message]
    end

    Result.new(project, message, reference)
  end

  def commit_pattern
    %r{
      ^[[:blank:]]*
      checkout
      [[:blank:]]+
      ['"]?
      (?<reference>.+)
      ['"]?
      [[:blank:]]+
      ['"]?
      (?<project>.+)
      ['"]?
      [[:blank:]]*$
    }x
  end

  def message_pattern
    %r{
      ^[[:blank:]]*
      \#[[:blank:]]+Commit:[[:blank:]]+
      (?<message>.+)
      [[:blank:]]*
      $
    }x
  end

  Result = ::Struct.new(:project, :commit_message, :current_ref) do
    def next_ref
      puts "Getting next ref (Project: #{project}, Commit Message: #{commit_message.inspect}, Current Ref: #{current_ref})"

      if current_ref == "master"
        next_ref = current_ref
      else
        pattern = Regexp.escape(commit_message)

        git_cmd = %{git -C #{project} log --format=format:%h --grep="^#{pattern}$" -E master}

        puts "Command: #{git_cmd}"

        next_ref = `#{git_cmd}`.chomp
      end

      if next_ref.empty?
        fail "Could not find ref (Project: #{project}, Commit Message: #{commit_message.inspect}, Current Ref: #{current_ref})"
      end

      puts "Get next ref done (Project: #{project}, Commit Message: #{commit_message.inspect}, Current Ref: #{current_ref}, Next Ref: #{next_ref})"

      next_ref
    end
  end
end

def update_step(step_script, current_ref, next_ref)
  original_text = File.read(step_script)

  updated_text = original_text.gsub(current_ref, next_ref)

  File.write(step_script, updated_text)
end

def update_step_script(step_script)
  result = Parse.(step_script)

  current_ref = result.current_ref

  next_ref = result.next_ref

  unless current_ref == next_ref
    update_step(step_script, current_ref, next_ref)
  end

  system(step_script) or fail "Could not run step script: #{step_script}"
end

puts <<~TEXT
Updating git commit SHAs for step scripts
= = =

TEXT

step_scripts = Dir["step/*"].grep(%r{/[[:digit:]]+\z}).sort do |a, b|
  File.basename(a).to_i <=> File.basename(b).to_i
end

step_scripts.each do |step_script|
  puts <<~TEXT
  Script: #{step_script}
  - - -
  TEXT

  update_step_script(step_script)

  puts
end

require 'rubygems'

$stdout = $stderr

gemspec_path = ENV.fetch('GEMSPEC') do
  fail "ERROR: Must supply a gemspec path via ENV['GEMSPEC']"
end

version_level = ENV.fetch('LEVEL') do
  $stderr.puts <<~ERROR_MESSAGE
  Must supply a version level via ENV['LEVEL']. Value must be one of these:

          patch      0.0.0.1 -> 0.0.0.2
          minor      0.0.1.2 -> 0.0.2.0
          major      0.1.2.3 -> 0.2.0.0
          generation 1.2.3.4 -> 2.0.0.0

  ERROR_MESSAGE

  fail
end

puts <<~TEXT
Loading Gemspec (#{gemspec_path})
- - -
TEXT

gemspec = Gem::Specification.load(gemspec_path)

if gemspec.nil?
  fail "Gemspec not found at #{gemspec_path}"
end

puts <<~TEXT
Gemspec #{gemspec_path} was loaded

TEXT

current_version = gemspec.version

level_ordinal = {
  'patch' => 3,
  'minor' => 2,
  'major' => 1,
  'generation' => 0
}.fetch(ENV['LEVEL']) do
  fail "Invalid level name #{ENV['LEVEL'].inspect}"
end

next_version_segments = current_version.segments.map.with_index do |value, level|
  if level < level_ordinal
    value
  elsif level == level_ordinal
    value.to_i.next.to_s
  else
    '0'
  end
end

next_version = next_version_segments * '.'

dry_run = !ENV['DRY_RUN'].to_s.match?(/\A(?:off|no|n|false|f|0)\z/i)

command = <<~SH.chomp
ruby -p -i -e 'gsub(#{current_version.to_s.inspect}, #{next_version.to_s.inspect})' #{gemspec_path}
SH

puts <<~TEXT
#{'(Dry run) ' if dry_run}Replacing Version Identifier
- - -
Gem Name: #{gemspec.name}
Current Version: #{current_version}
Next Version: #{next_version}
Command: #{command}

TEXT

STDOUT.puts <<~TEXT
#{current_version}
#{next_version}
TEXT
STDOUT.flush

exec command unless dry_run

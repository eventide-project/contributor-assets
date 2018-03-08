set -e

obsolete_labels=(
  "bug"
  "change"
  "consider"
  "consideration"
  "critique"
  "declined"
  "duplicate"
  "enhancement"
  "feature"
  "feature"
  "good%20first%20issue"
  "help%20wanted"
  "improvement"
  "imrpovement"
  "invalid"
  "materials"
  "problem"
  "problem"
  "question"
  "suggestion"
  "suggestion"
  "wontfix"
)

standard_labels=(
  '{"name":"consideration","description":"Potential to be an improvement or feature but needs more thought.","color":"daf4f0"}'
  '{"name":"critique","description":"Pick a friendly fight -Katsuaki Watanabe","color":"c5def5"}'
  '{"name":"declined","description":"Does not reflect current or intended design or standards","color":"a5a5a5"}'
  '{"name":"duplicate","description":"A prior item exists or may exist for this matter","color":"e1e1e1"}'
  '{"name":"feature","description":"Capability or functionality to be implemented","color":"0e8a16"}'
  '{"name":"good first issue","description":"Relatively straight-forward, provided guidance and stewardship from project principals","color":"5319e7"}'
  '{"name":"help wanted","description":"Looking for someone to take on the work, with guidance and stewardship from project principals","color":"d3fc62"}'
  '{"name":"improvement","description":"Something that will be implemented to make an improvement or enhancement","color":"c2e0c6"}'
  '{"name":"materials","description":"Documentation, presentations, work shops","color":"fffaf0"}'
  '{"name":"mistake","description":"Something is not right or does not meet standards and needs correction","color":"ff9500"}'
  '{"name":"problem","description":"Malfunction, bug, defect, aberration, irregularity, flaw, error, fault, and the like","color":"d91f0b"}'
  '{"name":"question","description":"A matter that requires clarification","color":"22f726"}'
  '{"name":"suggestion","description":"A feature or a change you would like to have considered","color":"d4c5f9"}'
)

API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?address='.freeze
REVERSE_API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='.freeze

TYPE_LOCATION = [{ content_type: 'location' }]

MENU_REPLIES = [
  {
    content_type: 'text',
    title: 'Hugot Line',
    payload: 'HUGOTLINE'
  }
].freeze

HELP_TEXT = 'Palihug gamit sa menu sa mga aksyon or itype kini.'.freeze

IDIOMS = {
	unknown_command: "Pasensya bai, wa pa ko kasabot ana ron. #{HELP_TEXT}",
  menu_greeting: "Maayong adlaw, unsa ako ikaalagad? #{HELP_TEXT}"
}.freeze

HUGOT_LINES = YAML.load_file('hugot_lines.yml')

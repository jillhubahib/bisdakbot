MENU_REPLIES = [
  {
    content_type: 'text',
    title: 'Hugot Line',
    payload: 'HUGOTLINE'
  }
].freeze

IDIOMS = {
	unknown_command: 'Pasayloa ko bai, wa pa ko kasabot ana ron. Hugot lines lng sa ta.',
  menu_greeting: 'Maayong adlaw, unsa ako ikaalagad?'
}.freeze

HELP_TEXT = "Type lng ug 'hugot' or gamita ang Menu."

HUGOT_LINES = YAML.load_file('hugot_lines.yml') 

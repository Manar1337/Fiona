extends LineEdit

var actual_input: String = ""
const MAX_LENGTH: int = 12

func _ready():
	editable = false
	text = ".".repeat(MAX_LENGTH)
	caret_column = 0

func _gui_input(event):
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_BACKSPACE:
			actual_input = actual_input.substr(0, actual_input.length() - 1)
		elif event.keycode in [KEY_ENTER, KEY_KP_ENTER]:
			emit_signal("text_submitted", actual_input)
			actual_input = ""
		elif event.unicode >= 32 and actual_input.length() < MAX_LENGTH:
			actual_input += char(event.unicode)
		_update_display_text()
		accept_event()

func _update_display_text():
	text = actual_input.to_upper() + ".".repeat(MAX_LENGTH - actual_input.length())
	caret_column = actual_input.length()

class_name SwitchingLabel

extends Label


@onready var switch_timer = $SwitchTimer as Timer

@export var text_speed: float = 1.0


var text_lines: Array = []

var current_line: int = 0

func _ready():
	switch_timer.wait_time = text_speed
	switch_timer.start()
	update_text()

func _on_switch_timer_timeout():
	update_text()

func update_text():
	if text_lines.size() > 0:
		set_text(text_lines[current_line])
		current_line = (current_line + 1) % text_lines.size()
	else:
		set_text("")

func set_lines(lines: Array):
	text_lines = lines
	current_line = 0
	update_text()

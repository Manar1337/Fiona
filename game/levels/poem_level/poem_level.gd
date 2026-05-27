extends Node

@onready var label_0: Label = $Label0
@onready var label_1: Label = $Label1
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3
@onready var label_4: Label = $Label4

func _ready() -> void:
	label_0 .hide()
	label_1 .hide()
	label_2 .hide()
	label_3 .hide()
	label_4 .hide()
	
	show_line(GameData.poem_level)

func _input(_event: InputEvent):
	if Input.is_action_just_pressed("fire"):
		SignalHandler.next_level_requested.emit()

func show_line(lineNr):
	if lineNr >0:
		label_0.show()
		label_1.show()
	if lineNr >1:
		label_2.show()
	if lineNr >2:
		label_3.show()
	if lineNr >3:
		label_4.show()

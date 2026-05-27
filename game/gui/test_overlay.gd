class_name TestOverlay
extends Control

const SECTION_SIGN_UNICODE := 167
const UI_FONT_SIZE := 15

var panel: Control
var background: ColorRect
var section_grid: GridContainer
var start_option: OptionButton
var invulnerable_check: CheckBox
var high_score_check: CheckBox
var skip_poems_check: CheckBox
var auto_return_check: CheckBox
var extreme_wall_button: Button
var score_spin: SpinBox
var lives_spin: SpinBox
var spellpower_spin: SpinBox
var walking_magic_to_win_spin: SpinBox
var tunnel_speed_spin: SpinBox
var tunnel_sequence_edit: LineEdit
var enemy_all_checks := {}
var enemy_checks := {}

func _ready() -> void:
	if not TestSettings.is_available():
		queue_free()
		return

	process_mode = Node.PROCESS_MODE_ALWAYS
	set_process_input(true)
	_resize_to_viewport()
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = true
	_build_ui()
	_sync_from_settings()
	_set_open(false)

func _input(event: InputEvent) -> void:
	_handle_key_event(event)

func _handle_key_event(event: InputEvent) -> void:
	if not TestSettings.is_available():
		return
	if not (event is InputEventKey) or not event.pressed or event.echo:
		return

	if _is_toggle_event(event):
		_set_open(not panel.visible)
		get_viewport().set_input_as_handled()

func _build_ui() -> void:
	panel = Control.new()
	panel.position = Vector2.ZERO
	panel.size = size
	add_child(panel)

	background = ColorRect.new()
	background.color = Color(0.02, 0.02, 0.04, 0.92)
	background.position = Vector2.ZERO
	background.size = size
	panel.add_child(background)

	var root = VBoxContainer.new()
	root.position = Vector2(14, 14)
	root.size = size - Vector2(28, 28)
	root.add_theme_constant_override("separation", 10)
	panel.add_child(root)

	section_grid = GridContainer.new()
	section_grid.columns = 2
	section_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	section_grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	section_grid.add_theme_constant_override("h_separation", 10)
	section_grid.add_theme_constant_override("v_separation", 10)
	root.add_child(section_grid)

	var general_panel = _add_section(section_grid, "GENERAL")
	var flying_panel = _add_section(section_grid, "FLYING")
	var death_panel = _add_section(section_grid, "DEATH")
	var platform_panel = _add_section(section_grid, "PLATFORM")

	start_option = OptionButton.new()
	for i in range(TestSettings.TARGETS.size()):
		start_option.add_item(TestSettings.TARGETS[i].label, i)
	_style_control(start_option)
	general_panel.add_child(start_option)

	var start_buttons = HBoxContainer.new()
	start_buttons.add_theme_constant_override("separation", 6)
	general_panel.add_child(start_buttons)
	_add_button(start_buttons, "Apply + Restart", _on_apply_restart_pressed)
	_add_button(start_buttons, "Reload Current", _on_reload_current_pressed)

	invulnerable_check = _add_check(general_panel, "Fiona invulnerable")
	high_score_check = _add_check(general_panel, "Disable high scoring")
	skip_poems_check = _add_check(general_panel, "Skip poem screens")
	score_spin = _add_spin(general_panel, "Start score", 0, 999999, 100)
	lives_spin = _add_spin(general_panel, "Start lives", 0, 99, 1)
	spellpower_spin = _add_spin(general_panel, "Start spellpower", 0, 9999, 100)

	_add_enemy_group(flying_panel, "flying")
	_add_enemy_group(platform_panel, "walking")
	walking_magic_to_win_spin = _add_spin(platform_panel, "Magic to win", 0, 9999, 100)

	auto_return_check = _add_check(death_panel, "Auto-return from death")
	extreme_wall_button = _add_button(death_panel, "", _on_extreme_wall_pressed)
	tunnel_speed_spin = _add_spin(death_panel, "Tunnel speed", 0, 300, 5)
	_add_label(death_panel, "Tunnel sequence")
	tunnel_sequence_edit = LineEdit.new()
	tunnel_sequence_edit.placeholder_text = "straight, drift, path, lane_target"
	_style_control(tunnel_sequence_edit)
	death_panel.add_child(tunnel_sequence_edit)
	_add_label(death_panel, "Blank=random  1=straight  2=path  3=drift  4=lane_target")
	_add_button(death_panel, "Apply + Load Death", _on_apply_death_pressed)

	var quick_body = _add_section(root, "QUICK LOAD")
	var quick_grid = GridContainer.new()
	quick_grid.columns = 7
	quick_grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	quick_grid.add_theme_constant_override("h_separation", 6)
	quick_grid.add_theme_constant_override("v_separation", 4)
	quick_body.add_child(quick_grid)
	for target in TestSettings.TARGETS:
		_add_button(quick_grid, target.label, func(target_id = target.id): _on_quick_target_pressed(target_id))

func _sync_from_settings() -> void:
	start_option.select(TestSettings.get_start_target_index())
	invulnerable_check.button_pressed = TestSettings.fiona_invulnerable
	high_score_check.button_pressed = TestSettings.disable_high_score
	skip_poems_check.button_pressed = TestSettings.skip_poems
	auto_return_check.button_pressed = TestSettings.auto_return_death
	_update_extreme_wall_button()
	score_spin.value = TestSettings.start_score
	lives_spin.value = TestSettings.start_lives
	spellpower_spin.value = TestSettings.start_spellpower
	walking_magic_to_win_spin.value = TestSettings.walking_magic_to_win
	tunnel_speed_spin.value = TestSettings.tunnel_speed
	tunnel_sequence_edit.text = TestSettings.tunnel_sequence_text

	for group_name in enemy_all_checks.keys():
		enemy_all_checks[group_name].button_pressed = TestSettings.enemy_all_enabled[group_name]
	for group_name in enemy_checks.keys():
		for enemy_name in enemy_checks[group_name].keys():
			enemy_checks[group_name][enemy_name].button_pressed = TestSettings.enemy_enabled[group_name][enemy_name]

func _save_to_settings() -> void:
	TestSettings.start_target_id = TestSettings.TARGETS[start_option.selected].id
	TestSettings.fiona_invulnerable = invulnerable_check.button_pressed
	TestSettings.disable_high_score = high_score_check.button_pressed
	TestSettings.skip_poems = skip_poems_check.button_pressed
	TestSettings.auto_return_death = auto_return_check.button_pressed
	TestSettings.start_score = int(score_spin.value)
	TestSettings.start_lives = int(lives_spin.value)
	TestSettings.start_spellpower = int(spellpower_spin.value)
	TestSettings.walking_magic_to_win = int(walking_magic_to_win_spin.value)
	TestSettings.tunnel_speed = float(tunnel_speed_spin.value)
	TestSettings.tunnel_sequence_text = tunnel_sequence_edit.text

	for group_name in enemy_all_checks.keys():
		TestSettings.enemy_all_enabled[group_name] = enemy_all_checks[group_name].button_pressed
	for group_name in enemy_checks.keys():
		for enemy_name in enemy_checks[group_name].keys():
			TestSettings.enemy_enabled[group_name][enemy_name] = enemy_checks[group_name][enemy_name].button_pressed

	TestSettings.reset_tunnel_sequence()
	TestSettings.notify_changed()

func _on_apply_restart_pressed() -> void:
	_save_to_settings()
	TestSettings.apply_start_values()
	TestSettings.request_start_target()

func _on_reload_current_pressed() -> void:
	_save_to_settings()
	TestSettings.apply_start_values()
	TestSettings.reload_current_level()

func _on_apply_death_pressed() -> void:
	_save_to_settings()
	TestSettings.apply_start_values()
	TestSettings.request_target("death")

func _on_extreme_wall_pressed() -> void:
	TestSettings.extreme_wall_enabled = not TestSettings.extreme_wall_enabled
	TestSettings.reset_tunnel_sequence()
	_update_extreme_wall_button()
	TestSettings.notify_changed()
	if GameData.current_level_type == LevelConstants.LevelType.DEATH:
		TestSettings.request_target("death")

func _on_quick_target_pressed(target_id: String) -> void:
	_save_to_settings()
	TestSettings.apply_start_values()
	TestSettings.request_target(target_id)

func _add_section(root: Container, title: String) -> VBoxContainer:
	var panel_container = PanelContainer.new()
	panel_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel_container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(panel_container)

	var body = VBoxContainer.new()
	body.add_theme_constant_override("separation", 4)
	panel_container.add_child(body)
	_add_heading(body, title)
	return body

func _add_enemy_group(root: VBoxContainer, group_name: String) -> void:
	enemy_all_checks[group_name] = _add_check(root, "All enemies")
	enemy_checks[group_name] = {}
	for enemy_name in TestSettings.ENEMY_TYPES[group_name]:
		enemy_checks[group_name][enemy_name] = _add_check(root, enemy_name.capitalize())

func _add_heading(root: VBoxContainer, text: String) -> void:
	var label = Label.new()
	label.text = text
	label.add_theme_color_override("font_color", Color(0.7, 0.95, 1.0))
	_style_control(label)
	root.add_child(label)

func _add_label(root: VBoxContainer, text: String) -> void:
	var label = Label.new()
	label.text = text
	_style_control(label)
	root.add_child(label)

func _add_check(root: VBoxContainer, text: String) -> CheckBox:
	var check = CheckBox.new()
	check.text = text
	_style_control(check)
	root.add_child(check)
	return check

func _add_spin(root: VBoxContainer, label_text: String, min_value: float, max_value: float, step: float) -> SpinBox:
	var row = HBoxContainer.new()
	row.add_theme_constant_override("separation", 2)
	root.add_child(row)
	var label = Label.new()
	label.text = label_text
	label.custom_minimum_size.x = 160
	_style_control(label)
	row.add_child(label)
	var spin = SpinBox.new()
	spin.min_value = min_value
	spin.max_value = max_value
	spin.step = step
	spin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_style_control(spin)
	_style_spin_children(spin)
	row.add_child(spin)
	return spin

func _add_button(root: Container, text: String, callback: Callable) -> Button:
	var button = Button.new()
	button.text = text
	_style_control(button)
	button.pressed.connect(callback)
	root.add_child(button)
	return button

func _update_extreme_wall_button() -> void:
	if extreme_wall_button == null:
		return
	extreme_wall_button.text = "Extreme wall: " + ("On" if TestSettings.extreme_wall_enabled else "Off")

func _set_open(is_open: bool) -> void:
	panel.visible = is_open
	mouse_filter = Control.MOUSE_FILTER_STOP if is_open else Control.MOUSE_FILTER_IGNORE

func _is_toggle_event(event: InputEvent) -> bool:
	if event.unicode == SECTION_SIGN_UNICODE:
		return true
	if event.keycode == SECTION_SIGN_UNICODE:
		return true
	if event.key_label == SECTION_SIGN_UNICODE:
		return true
	if event.physical_keycode == SECTION_SIGN_UNICODE:
		return true
	return event.keycode == KEY_F10 or event.physical_keycode == KEY_F10 or event.keycode == KEY_BACKSLASH or event.physical_keycode == KEY_BACKSLASH

func _resize_to_viewport() -> void:
	var viewport_size = get_viewport_rect().size

	position = Vector2.ZERO
	scale = Vector2.ONE
	size = viewport_size
	if panel == null:
		return

	panel.position = Vector2.ZERO
	panel.size = size
	background.position = Vector2.ZERO
	background.size = size

func _style_control(control: Control) -> void:
	control.add_theme_font_size_override("font_size", UI_FONT_SIZE)

func _style_spin_children(spin: SpinBox) -> void:
	for child in spin.get_children():
		if child is Control:
			_style_control(child)

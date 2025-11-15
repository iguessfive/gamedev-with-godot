class_name LocalPlayerInputs extends RefCounted

func load_player_inputs() -> void:
	var actions: Dictionary[String, Array] = {
		move_left(): move_left_events(), # {"name", "events"}
		move_right(): move_right_events(),
		move_up(): move_up_events(),
		move_down(): move_down_events(),
		shoot(): shoot_events(),
	}

	for action_name in actions:
		InputMap.add_action(action_name)
		var events = actions[action_name]
		for event in events:
			InputMap.action_add_event(action_name, event)

func move_left() -> String:
	return "move_left"
	
func move_right() -> String:
	return "move_right"
	
func move_up() -> String:
	return "move_up"
	
func move_down() -> String:
	return "move_down"
	
func shoot() -> String:
	return "shoot"

func move_left_events() -> Array[InputEvent]:
	var events: Array[InputEvent] = []
	
	var key_a = InputEventKey.new()
	key_a.key_label = KEY_A
	var key_left = InputEventKey.new()
	key_left.key_label = KEY_LEFT
	var left_joystick = InputEventJoypadMotion.new()
	left_joystick.axis = JOY_AXIS_LEFT_X
	left_joystick.axis_value = -1
	
	events.append_array([key_a, key_left, left_joystick])
	
	return events

func move_right_events() -> Array[InputEvent]:
	var events: Array[InputEvent] = []
	
	var key_d = InputEventKey.new()
	key_d.key_label = KEY_D
	var key_right = InputEventKey.new()
	key_right.key_label = KEY_RIGHT
	var right_joystick = InputEventJoypadMotion.new()
	right_joystick.axis = JOY_AXIS_LEFT_X
	right_joystick.axis_value = 1
	
	events.append_array([key_d, key_right, right_joystick])
	
	return events

func move_up_events() -> Array[InputEvent]:
	var events: Array[InputEvent] = []
	
	var key_w = InputEventKey.new()
	key_w.key_label = KEY_W
	var key_up = InputEventKey.new()
	key_up.key_label = KEY_UP
	var up_joystick = InputEventJoypadMotion.new()
	up_joystick.axis = JOY_AXIS_LEFT_Y
	up_joystick.axis_value = -1
	
	events.append_array([key_w, key_up, up_joystick])
	
	return events

func move_down_events() -> Array[InputEvent]:
	var events: Array[InputEvent] = []
	
	var key_s = InputEventKey.new()
	key_s.key_label = KEY_S
	var key_down = InputEventKey.new()
	key_down.key_label = KEY_DOWN
	var down_joystick = InputEventJoypadMotion.new()
	down_joystick.axis = JOY_AXIS_LEFT_Y
	down_joystick.axis_value = 1
	
	events.append_array([key_s, key_down, down_joystick])
	
	return events

func shoot_events() -> Array[InputEvent]:
	var events: Array[InputEvent] = []
	
	var key_space = InputEventKey.new()
	key_space.key_label = KEY_SPACE
	var mouse_left = InputEventMouseButton.new()
	mouse_left.button_index = MOUSE_BUTTON_LEFT
	var joypad_a = InputEventJoypadButton.new()
	joypad_a.button_index = JOY_BUTTON_A
	
	events.append_array([key_space, mouse_left, joypad_a])
	
	return events

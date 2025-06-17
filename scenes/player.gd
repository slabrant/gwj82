extends CharacterBody3D

@onready var thump_sound: AudioStreamPlayer3D = $ThumpSound

const SPEED : int = 7
const MOUSE_SENSITIVITY : float = 0.005
const JOYSTICK_SENSITIVITY : float = 0.1


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# The mouse will always work to look left and right
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x * MOUSE_SENSITIVITY


func _physics_process(delta: float) -> void:
	var yaw = Input.get_action_strength("input_look_right") - Input.get_action_strength("input_look_left")
	rotation.y -= yaw * JOYSTICK_SENSITIVITY
	var forward = -global_transform.basis.z
	var right = global_transform.basis.x
	
	var x_direction = Input.get_action_strength("input_right") - Input.get_action_strength("input_left")
	var z_direction = Input.get_action_strength("input_forward") - Input.get_action_strength("input_backward")
	var direction = (x_direction * right + z_direction * forward)
	
	var run_factor = 2 if Input.is_action_pressed("input_run") else 1
	var total_speed = SPEED * run_factor
	
	velocity = lerp(velocity, direction * total_speed, 0.2)
		
	move_and_slide()
	
	if get_slide_collision(0) and 0.01 < velocity.length():
		#thump_sound.volume_linear = velocity.length() * 0.5
		thump_sound.global_position = get_slide_collision(0).get_position()
		play_thump_sound()
	else:
		play_thump_sound(false)


func play_thump_sound(on = true):
	if (thump_sound.playing and on) or (!thump_sound.playing and !on):
		return
	
	if thump_sound.playing:
		thump_sound.stop()
	else:
		thump_sound.play(randf_range(0.0, thump_sound.stream.get_length()))
		

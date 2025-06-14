extends CharacterBody3D

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

extends CharacterBody3D

@export var CHASING : bool = false
@export var MOVEMENT_SPEED: float = 3.0

@onready var follow_timer: Timer = $FollowTimer
@onready var mom_navigation: NavigationAgent3D = $MomNavigation
@onready var detection_area: Area3D = $DetectionArea
@onready var walking_sound: AudioStreamPlayer3D = $WalkingSound


func _ready() -> void:
	print("Mom ready; connecting signals…")
	$DetectionArea.body_entered.connect(self._on_body_entered)
	$DetectionArea.body_exited.connect(self._on_body_exited)
	walking_sound.stop()


func _physics_process(delta):
	var old_velocity = velocity
	if Input.is_action_just_pressed("input_run"):
		CHASING = !CHASING
	
	if CHASING:
		mom_navigation.set_target_position(get_node("../Player").global_position)
		var next_point = mom_navigation.get_next_path_position()
		velocity = (next_point - global_position).normalized() * MOVEMENT_SPEED
		look_at(next_point)
	else:
		velocity = Vector3.ZERO
	
	if (Vector3.ZERO == velocity) != (Vector3.ZERO == old_velocity):
		toggle_walking_sound()
	
	move_and_slide()


func toggle_walking_sound():
	if walking_sound.playing == true:
		walking_sound.stop()
	else:
		walking_sound.play(randf_range(0.0, walking_sound.stream.get_length()))


func _on_body_entered(body):
	CHASING = true
	print("DetectionArea body_entered → ", body.name)
func _on_body_exited(body):
	print("DetectionArea body_exited  ← ", body.name)

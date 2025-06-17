extends CharacterBody3D

@export var CHASING : bool = false
@export var MOVEMENT_SPEED: float = 3.0
@export var TOUCH_RADIUS: float = 1.5

@onready var target_position: Vector3
@onready var navigation_region_3d = get_node("../NavigationRegion3D")

@onready var follow_timer: Timer = $FollowTimer
@onready var mom_navigation: NavigationAgent3D = $MomNavigation
@onready var detection_area: Area3D = $DetectionArea
@onready var walking_sound: AudioStreamPlayer3D = $WalkingSound


func _ready() -> void:
	print("Mom ready; connecting signals…")
	$DetectionArea.body_entered.connect(self._on_body_entered)
	#$DetectionArea.body_exited.connect(self._on_body_exited)
	walking_sound.stop()
	target_position = new_target()


func _physics_process(delta):
	var old_velocity = velocity
	var current_speed = MOVEMENT_SPEED
	if CHASING:
		current_speed *= 2
		walking_sound.pitch_scale = 2.0
		target_position = get_node("../Player").global_position
	
	mom_navigation.set_target_position(target_position)
	var next_point = mom_navigation.get_next_path_position()
	velocity = (next_point - global_position).normalized() * MOVEMENT_SPEED
	look_at(next_point)
	
	if mom_navigation.distance_to_target() < TOUCH_RADIUS:
		target_position = new_target()
		#if CHASING:
			#print("caught")
		#else:
			#print("new point")
	
	if (Vector3.ZERO == velocity) != (Vector3.ZERO == old_velocity):
		toggle_walking_sound()
	
	move_and_slide()


func toggle_walking_sound():
	if walking_sound.playing == true:
		walking_sound.stop()
	else:
		walking_sound.play(randf_range(0.0, walking_sound.stream.get_length()))



func new_target():
	return get_random_point_in_aabb(navigation_region_3d.get_bounds())


func _on_body_entered(body):
	CHASING = true
	#print("DetectionArea body_entered → ", body.name)
#func _on_body_exited(body):
	#print("DetectionArea body_exited  ← ", body.name)

func get_random_point_in_aabb(aabb: AABB) -> Vector3:
	var rand_x = randf_range(aabb.position.x, aabb.position.x + aabb.size.x)
	var rand_y = randf_range(aabb.position.y, aabb.position.y + aabb.size.y)
	var rand_z = randf_range(aabb.position.z, aabb.position.z + aabb.size.z)
	return Vector3(rand_x, rand_y, rand_z)

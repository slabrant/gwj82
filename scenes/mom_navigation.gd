extends NavigationAgent3D

@onready var parent = get_parent()

func _ready():
	path_desired_distance = 0.5
	target_desired_distance = 0.5

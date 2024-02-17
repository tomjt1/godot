extends Node2D

@export var wander_range = 32

@onready var start_position = global_position #get start pos of enemy
@onready var target_position = global_position #wander position
@onready var timer = $Timer

func _ready():
	start_position = global_position
	update_target_position()

func update_target_position():
	var target_vector = Vector2(randf_range(-wander_range,wander_range), randf_range(-wander_range,wander_range))
	target_position = start_position + target_vector

func get_time_left():
	return timer.time_left

func start_wander_timer(duration):
	timer.start(duration)

func _on_timer_timeout(): #creates a new wander location every second
	update_target_position()

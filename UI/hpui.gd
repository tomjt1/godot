extends Control

@onready var heartUIFull = $HeartUIFull
@onready var heartUIEmpty = $HeartUIEmpty

var max_hearts = 4:
	get:
		return max_hearts
	set(value):
		max_hearts = max(value, 1) #max hearts cannot be less than 1
		if heartUIEmpty != null:
			heartUIEmpty.size.x = max_hearts * 15

var hearts = 4:
	get:
		return hearts
	set(value):
		hearts = clamp(value, 0, max_hearts) #current hearts between 0 and max
		hearts = min(hearts, max_hearts)
		if heartUIFull != null:
			heartUIFull.size.x = hearts * 15

func set_hearts(value):
	hearts = value

func set_max_hearts(value):
	max_hearts = value

func _ready():
	self.max_hearts = PlayerStats.max_hp
	self.hearts = PlayerStats.hp
	PlayerStats.hp_changed.connect(set_hearts)
	PlayerStats.max_hp_changed.connect(set_max_hearts)


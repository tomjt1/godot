extends Label

@onready var timer = $Timer

func _ready():
	self.visible = false

func display(value):
	self.visible = true
	if value <= 0:
		self.text = "HP Full"
	else:
		self.text = str(value)
	timer.start()

func _on_timer_timeout():
	self.visible = false

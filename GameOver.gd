extends Control

#Show scores

@onready var timer = $Timer
@onready var soundEffect = $AudioStreamPlayer
@onready var killLabel = $KillLabel
@onready var timeLabel = $TimeLabel
@onready var moneyLabel = $MoneyLabel
@onready var gameoverLabel = $GameOverLabel

var time_start = 0
var time_now = 0
var time_elapsed

var cycles = 0

func _ready():
	killLabel.visible = false
	timeLabel.visible = false
	moneyLabel.visible = false
	gameoverLabel.visible = false
	time_start = Time.get_unix_time_from_system()

func _on_player_dead():
	timer.start()
	time_now = Time.get_unix_time_from_system()
	time_elapsed = time_now - time_start
	gameoverLabel.visible = true

func _on_timer_timeout():
	if cycles == 0:
		killLabel.visible = true
		timer.start()
	if cycles == 1:
		killLabel.text += str(PlayerStats.totalEnemiesKilled)
		timer.start()
	if cycles == 2:
		moneyLabel.visible = true
		timer.start()
	if cycles == 3:
		moneyLabel.text += str(PlayerStats.totalMoney)
		timer.start()
	if cycles == 4:
		timeLabel.visible = true
		timer.start()
	if cycles == 5:
		timeLabel.text += time_convert(int(time_elapsed))
	soundEffect.play()
	cycles += 1

func time_convert(time_in_sec):
	var seconds = time_in_sec%60
	var minutes = (time_in_sec/60)%60
	var hours = (time_in_sec/60)/60
	
	#returns a string with the format "HH:MM:SS"
	return "%02d:%02d:%02d" % [hours, minutes, seconds]

extends AudioStreamPlayer

@onready var musicPlayer = $MusicPlayer #beginning
@onready var timer =$Timer

func _on_music_player_finished():
	play()

func _on_finished():
	play()

func _on_player_dead():
	timer.start()

func get_active_track():
	if self.playing:
		return self
	elif musicPlayer.playing:
		return musicPlayer

func _on_timer_timeout(): #slow then stop
	if get_active_track().pitch_scale > 0.1:
		get_active_track().pitch_scale -= 0.05
		get_active_track().volume_db -= 1
		timer.start()
	else:
		queue_free()

extends Area2D

var player = null

func can_see_player():
	return player != null

func _on_body_entered(body):#inside detection zone
	player = body
	#print("Player entered!")

func _on_body_exited(_body):#outside detection zone
	player = null
	#print("Player exited...")

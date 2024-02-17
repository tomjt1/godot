extends CharacterBody2D

const PlayerHurtSound = preload("res://Player/player_hurt_sound.tscn")
const BlockedDamageSound = preload("res://Player/blocked_damage_sound.tscn")

var MAX_SPEED = 80 * PlayerStats.speed
var ROLL_SPEED = 125 * PlayerStats.speed
var ACCEL = 500 * PlayerStats.speed
var FRICTION = 520 * PlayerStats.friction
@export var INVINCIBILITY_DURATION = .6

signal dead

enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var roll_vector = Vector2.LEFT #Starting player position
var stats = PlayerStats

#access animations
@onready var animation_player = $AnimationPlayer
@onready var blink_animation_player = $BlinkAnimationPlayer
@onready var animation_tree = $AnimationTree
#access to the mesh
@onready var animation_state = $AnimationTree.get("parameters/playback")
@onready var swordHitbox = $HitboxPivot/hitboxSword
@onready var hurtbox = $hurtbox
@onready var damagePopup = $DamagePopup
@onready var hpPopup = $HpPopup
@onready var artifacts = $Artifacts
var healValue = 0

func _ready():
	swordHitbox.knockback_vector = roll_vector
	self.stats.no_hp.connect(death) #kill if no HP
	self.stats.speed_changed.connect(update_speed)
	self.stats.friction_changed.connect(update_speed)
	self.stats.hp_changed.connect(heal_manager, healValue)
	randomize() #generate random seed for game

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#state machine
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state()
		ATTACK:
			attack_state(delta)

#movement state
func move_state(delta):
	#calculate movement
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	#normalize vector to fix diagonal
	input_vector = input_vector.normalized()
	
	#moving
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector #roll direction keeps previous direction for entire roll and ignores input while roll
		swordHitbox.knockback_vector = input_vector #same as above, except for enemy knockback direction
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector) #in movement, so it can use input vector and not change direction
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_state.travel("Run")
		#Accelerate for smoother movement instead of just setting speed.
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCEL * delta)
	else:
		animation_state.travel("Idle")
		#Move towards a stopped vector, therefore slowing down
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	# move at framerate
	move_and_slide()
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func roll_state():
	velocity = roll_vector * ROLL_SPEED #Instantly reaches Roll Speed
	animation_state.travel("Roll")
	move_and_slide()

func attack_state(delta):
	if artifacts.slipnSlide.artifactEnabled == false:
		velocity = Vector2.ZERO
	elif artifacts.slipnSlide.artifactEnabled == true:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		move_and_slide()
	animation_state.travel("Attack")

func roll_animation_finished():
	velocity = velocity / 2 #reduce slide after roll
	state = MOVE

func attack_animation_finished():
	state = MOVE

func _on_hurtbox_area_entered(area):
	var damageTotal = area.damage - PlayerStats.defense
	if (damageTotal > 0):
		stats.hp -= damageTotal
		hurtbox.start_invincibility(INVINCIBILITY_DURATION)
		hurtbox.create_hit_effect()
		var playerHurtSound = PlayerHurtSound.instantiate()
		get_tree().current_scene.add_child(playerHurtSound)
	else:
		var blockedDamageSound = BlockedDamageSound.instantiate()
		get_tree().current_scene.add_child(blockedDamageSound)
	damagePopup.display(damageTotal)

func _on_hurtbox_invincibility_started():
	blink_animation_player.play("start")

func _on_hurtbox_invincibility_ended():
	blink_animation_player.play("stop")

func update_speed():
	MAX_SPEED = 80 * PlayerStats.speed
	ROLL_SPEED = 125 * PlayerStats.speed
	ACCEL = 500 * PlayerStats.speed
	FRICTION = 520 * PlayerStats.friction

func death():
	emit_signal("dead")
	queue_free()

func heal_manager(value):
	var hp_delta = value - stats.prev_hp
	if hp_delta >= 0:
		hpPopup.display(hp_delta)

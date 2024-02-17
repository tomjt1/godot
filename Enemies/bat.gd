extends CharacterBody2D

var knockback = Vector2.ZERO
@export var KNOCKBACK_SPEED = 120
@export var FRICTION = 200
@export var ACCELERATION = 300
@export var MAX_SPEED = 50
@export var WANDER_TARGET_VALUE = 5

const EnemyDeathEffect = preload("res://Effects/enemy_death_effect.tscn")
const MoneyEffect = preload("res://Effects/money_effect.tscn")
const BlockedDamageSound = preload("res://Player/blocked_damage_sound.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}
var state = IDLE
var angry = false

@onready var stats = $Stats
@onready var playerDetectionZone = $PlayerDetectionZone
@onready var sprite = $AnimatedSprite
@onready var hurtbox = $hurtbox
@onready var softCollision = $SoftCollision
@onready var wanderController = $WanderController
@onready var animationPlayer = $AnimationPlayer
@onready var angerTimer = $AngerTimer
@onready var hitbox = $hitbox
@onready var animatedSpriteAftershadow = $AnimatedSpriteAftershadow
@onready var damagePopup = $DamagePopup

func _ready():
	stats.money = randf_range(-1,1) + stats.money #money stat is the odds of it appearing
	wanderController.global_position = global_position
	angerTimer.start(70)
	animatedSpriteAftershadow.visible = false

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta) #set the speed equal to knockback when hit
	if (knockback != Vector2.ZERO): #move in knockback while its non-zero
		velocity = knockback
	match state: #AI state setup
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(randf_range(1,3))
		
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(randf_range(1,3))
				#print("wandering...")
			accelerate_towards_point(wanderController.target_position, delta)
			
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_VALUE:
				state = pick_random_state([IDLE, WANDER])
				wanderController.start_wander_timer(randf_range(1,3))
		
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
			sprite.flip_h = velocity.x < 0 #flip based on direction
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	move_and_slide()

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta) #move towards target
	sprite.flip_h = velocity.x < 0 #flip based on direction

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE
		#print("Start Chase!")

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_hurtbox_area_entered(area): #area is the area2D that enters the bat, aka sword hitbox
	var damageTotal = (PlayerStats.attack * PlayerStats.attack_multiplier) - stats.defense
	if damageTotal > 0:
		stats.hp -= damageTotal
		knockback = area.knockback_vector * KNOCKBACK_SPEED #set knockback when hit, k_v is based on SwordHitbox.gd.
		hurtbox.create_hit_effect()
		hurtbox.start_invincibility(0.4)
	else:
		var blockedDamageSound = BlockedDamageSound.instantiate()
		get_tree().current_scene.add_child(blockedDamageSound)
	damagePopup.display(damageTotal)
	

func _on_stats_no_hp(): #death
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instantiate() #create death effect instance
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.position = position #set death effect location to bat location
	if stats.money > 0:
		call_deferred("drop_money")
	PlayerStats.experience =+ stats.experience
	PlayerStats.totalEnemiesKilled += 1

func drop_money():
	var moneyEffect = MoneyEffect.instantiate() #create money instance
	get_parent().add_child(moneyEffect)
	moneyEffect.position = position #set money location to bat location

func _on_hurtbox_invincibility_ended():
	animationPlayer.play("stop")


func _on_hurtbox_invincibility_started():
	animationPlayer.play("start")


func _on_anger_timer_timeout():
	#get MAD!!!
	MAX_SPEED = 85
	ACCELERATION = 500
	KNOCKBACK_SPEED = 60
	hitbox.damage = 2
	stats.max_hp = 4
	stats.hp = 4
	angry = true
	animatedSpriteAftershadow.visible = true

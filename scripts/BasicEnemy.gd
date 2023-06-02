extends CharacterBody2D

var Gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var MaxHealth = 100
var CurrentHealth = MaxHealth
var Armor = 0.0
var Damage = 100.0
var Speed = 100.0
var Cooldown = false

var Direction = 1

# Existing statuses: 0 - idle, 1 - search, -1 - death
var CurrentStatus = 0
var CurrentState = "normal"

@onready var Body: CollisionShape2D = $BodyCollision
@onready var Weapon: Area2D = $AttackArea
@onready var Sprite: AnimatedSprite2D = $Sprite
@onready var Vision: Area2D = $VisionArea
@onready var Raycast: RayCast2D = $RayCast2D
@onready var EnemyTimer: Timer = $EnemyTimer
@onready var FrozenTimer: Timer = $FrozenTimer
@onready var Animator: AnimationTree = $AnimationTree
@onready var HPBar: TextureProgressBar = $HPBar
@onready var DamageLabel: Label = $DamageLabel
@onready var StateMachine = Animator.get("parameters/playback")


var Target = null

func _ready():
	pass 

func _physics_process(delta):
	if CurrentHealth <= 0:
		Animator.active = true
		HPBar.value = CurrentHealth
		death()
		return
		
	if CurrentState != "normal":
		frozen()
		HPBar.value = CurrentHealth 
		return
	
	if CurrentStatus == 0: # idle
		idle()
	elif CurrentStatus == 1: # search
		search()

	HPBar.value = CurrentHealth 
		
func idle():
	pass
	
func search():
	pass

func death():
	pass
	
func hurt(value):
	var inDamage
	if CurrentState == "frozen":
		inDamage = value * 1.4
	else:
		inDamage = value + (value * Armor * 0.01)
	
	print(inDamage)
	
	if inDamage >= CurrentHealth:
		DamageLabel.modulate = Color(255, 0, 0)
		DamageLabel.text = str(CurrentHealth) + "+"
	else:
		DamageLabel.modulate = Color(1, 1, 1)
		DamageLabel.text = str(inDamage)
	CurrentHealth -= inDamage
		
func _on_VisionArea_body_entered(body):
	if body.name == "player":
		Target = body
		CurrentStatus = 1
		
func _on_vision_area_body_exited(body):
	if body.name == "player":
		Target = null
		CurrentStatus = 0
		
func enemy():
	pass
	
func freeze(time, damage):
	hurt(damage)
	CurrentState = "frozen"
	if FrozenTimer.is_stopped():
		FrozenTimer.start(time)

func frozen():
	velocity = Vector2.ZERO
	Animator.active = false
	
func _on_timer_timeout():
	pass

func _on_frozen_timer_timeout():
	CurrentState = "normal"
	Animator.active = true
	

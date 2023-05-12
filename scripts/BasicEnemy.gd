extends CharacterBody2D


var Gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var MaxHealth = 100
var CurrentHealth = MaxHealth
var Armor = 0.0
var Damage = 100.0
var Speed = 100.0

@onready var Direction = 1

# Existing statuses: 0 - idle, 1 - search, 2 - attack, -1 - death
@onready var CurrentStatus = 0

var Body: CollisionShape2D
var Weapon: Area2D
var Sprite: AnimatedSprite2D
var Vision: Area2D

func _ready():
	Body = $BodyCollision
	Weapon = $AttackArea
	Sprite = $Sprite
	Vision = $VisionArea
	
	Sprite.play("idle") 

func _physics_process(delta):
	if CurrentStatus == 0: # idle
		idle()
	elif CurrentStatus == 1: # search
		search()
	elif CurrentStatus == 2: # attack
		attack()
	else:
		death()
		
func idle():
	Sprite.play("idle")
	
func search():
	Sprite.play("run")
	velocity.x = Direction * Speed * 1.4
	move_and_slide()

func attack():
	Sprite.play("attack")

func death():
	Sprite.play("death")
	
func hurt(value):
	CurrentHealth -= value + (value * Armor * 0.01)
	if CurrentHealth <= 0:
		CurrentStatus = -1

func _on_VisionArea_body_entered(body):
	pass 

func _on_timer_timeout():
	pass

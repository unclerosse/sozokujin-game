extends CharacterBody2D


const SPEED = 450.0
const JUMP_VELOCITY = -780.0 

@onready var MaxHealth: int = 100
@onready var CurrentHealth = MaxHealth

var _Agility = 1
var _Sanity = 1
var _Power = 1

var multiplier = 1.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var vel = Vector2()
func  _ready():
	CurrentHealth = MaxHealth
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta * 1.8

	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	var direction = Input.get_axis("player_left", "player_right")
	velocity.x = direction * SPEED * multiplier
	
	var right = Input.is_action_pressed("player_right")
	var left = Input.is_action_pressed("player_left")
	
	if (right or left) and $Timer.time_left == 0:
		$Timer.start()
	elif $Timer.time_left != 0 and not (right or left):
		multiplier = 1.0
		$Timer.stop()
		
	move_and_slide()
	animate()
	
func animate():
	if velocity.x == 0:
		$Sprite.play("idle")
	
	elif velocity.y == 0 and is_on_floor() and velocity.x != 0:
		$Sprite.play("run")
		if velocity.x > 0:
			$Sprite.flip_h = false
			$Sprite.set_offset( Vector2(0, 0) )
		else:
			$Sprite.flip_h = true
			$Sprite.set_offset( Vector2(-12, 0) )
	
	elif velocity.y != 0:
		$Sprite.play("idle")
		if velocity.x > 0:
			$Sprite.flip_h = false
			$Sprite.set_offset( Vector2(0, 0) )
		else:
			$Sprite.flip_h = true
			$Sprite.set_offset( Vector2(-12, 0) )

func hurt(value):
	var damage = value * MaxHealth * 0.01 * (1 - _Agility * 0.05)
	CurrentHealth -= damage
	print(damage)
	if CurrentHealth <= 0:
		pass

func getPlayerLevel():
	return _Agility + _Power + _Sanity

func increaseAgility():
	if getPlayerLevel() <= 16:
		_Agility += 1
		MaxHealth *= 1 + (getPlayerLevel() - 3) * 0.1 + (_Power - 1) * 0.15

func increasePower():
	if getPlayerLevel() <= 16:
		_Power += 1
		MaxHealth *= 1 + (getPlayerLevel() - 3) * 0.1 + (_Power - 1) * 0.15

func increaseSanity():
	if getPlayerLevel() <= 16:
		_Sanity += 1
		MaxHealth *= 1 + (getPlayerLevel() - 3) * 0.1 + (_Power - 1) * 0.15
	
	
func _on_Timer_timeout():
	if _Agility <= 2:
		multiplier = 1 + _Agility * 0.1
	elif _Agility <= 6:
		multiplier = 1.1 + _Agility * 0.05
	else:
		multiplier = 1.4

	

extends CharacterBody2D

const SPEED = 450.0
const JUMP_VELOCITY = -780.0 

var _MaxHealth = 100
var _CurrentHealth = _MaxHealth
var _IsAlive = true
var _HasSecondJump = true
var _HasSecondLife = true

var _Agility = 1
var _Sanity = 1
var _Power = 1

var multiplier = 1.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var Sprite: AnimatedSprite2D
var HUD: Control
var PlayerTimer: Timer

func  _ready():
	Sprite = $Sprite
	HUD = $HUD
	PlayerTimer = $Timer
	
func _physics_process(delta):
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("player_jump") and _HasSecondJump and not is_on_floor():
		velocity.y = JUMP_VELOCITY / 1.2
		_HasSecondJump = false
		
	if not is_on_floor():
		velocity.y += gravity * delta * 1.8
		if velocity.y > 1200.0:
			velocity.y = 1200.0
	
	if velocity.y == 0 and is_on_floor():
		_HasSecondJump = true
	
	var direction = Input.get_axis("player_left", "player_right")
	velocity.x = direction * SPEED * multiplier
	if velocity.x != 0 and PlayerTimer.is_stopped():
		PlayerTimer.start()
	elif velocity.x == 0:
		multiplier = 1.0
		PlayerTimer.stop()
	
	move_and_slide()
	animate()
	
func animate():
	if velocity.x > 0:
		Sprite.flip_h = false
	elif velocity.x < 0: 
		Sprite.flip_h = true
	else:
		pass
		
	if velocity.y < 0:
		Sprite.play("jump")
	elif velocity.y > 0:
		Sprite.play("fall")
	elif velocity.x == 0:
		Sprite.play("idle")

	if abs(velocity.x) > 0 and is_on_floor():
		Sprite.play("run")

func hurt(value):
	var damage = int(value * _MaxHealth * 0.01 * (1 - _Agility * 0.05))
	print(damage)
	ChangeHealth(-damage)

func ChangeHealth(value):
	if _CurrentHealth + value <= 0:
		if _HasSecondLife:
			_CurrentHealth = 1
			_HasSecondLife = false
		else: 
			get_tree().quit()
	elif _CurrentHealth + value <= _MaxHealth:
		_CurrentHealth += value
	else:
		_CurrentHealth = _MaxHealth
		
	HUD.set_hp(_CurrentHealth, _MaxHealth)

func getPlayerLevel():
	return _Agility + _Power + _Sanity

func increaseAgility():
	if getPlayerLevel() <= 16:
		_Agility += 1
		_MaxHealth *= 1 + (getPlayerLevel() - 3) * 0.1 + (_Power - 1) * 0.15

func increasePower():
	if getPlayerLevel() <= 16:
		_Power += 1
		_MaxHealth *= 1 + (getPlayerLevel() - 3) * 0.1 + (_Power - 1) * 0.15

func increaseSanity():
	if getPlayerLevel() <= 16:
		_Sanity += 1
		_MaxHealth *= 1 + (getPlayerLevel() - 3) * 0.1 + (_Power - 1) * 0.15
	
	
func _on_Timer_timeout():
	if _Agility <= 2:
		multiplier = 1 + _Agility * 0.1
	elif _Agility <= 6:
		multiplier = 1.1 + _Agility * 0.05
	else:
		multiplier = 1.4

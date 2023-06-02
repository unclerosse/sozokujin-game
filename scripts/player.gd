extends CharacterBody2D

@export var MAGIC: PackedScene = preload("res://scenes/magic.tscn")

const SPEED = 450.0
const JUMP_VELOCITY = -780.0 

var _MaxHealth = 100
var _CurrentHealth = _MaxHealth
var _IsAlive = true
var _HasSecondJump = true
var _HasSecondLife = true
var _CanFreeze = true

var _Agility = 1
var _Sanity = 1
var _Power = 1

var LightAttackDamage = 35
var HeavyAttackDamage = 100
var MagicAttackDamage = 12

var multiplier = 1.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var Sprite: AnimatedSprite2D
var HUD: Control
var PlayerTimer: Timer
var Animator: AnimationTree
var StateMachine
var FreezeCooldown: Timer

func  _ready():
	Sprite = $Sprite
	HUD = $HUD
	PlayerTimer = $Timer
	Animator = $AnimationTree
	StateMachine = Animator.get("parameters/playback")
	FreezeCooldown = $FreezeCooldown
		
func _physics_process(delta):
	
	var currentAnim = StateMachine.get_current_node()
	if not _IsAlive:
		velocity.x = 0
		if currentAnim == "End":
			get_tree().change_scene_to_file("res://scenes/death.tscn")
		elif not is_on_floor():
			velocity.y += gravity * delta * 1.8
			if velocity.y > 1200.0:
				velocity.y = 1200.0
		else:
			return
	
	if Input.is_action_just_pressed("player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("player_jump") and _HasSecondJump and not is_on_floor():
		velocity.y = JUMP_VELOCITY / 1.2
		_HasSecondJump = false
	
	
	if velocity.y == 0 and is_on_floor():
		_HasSecondJump = true
	
	var direction = Input.get_axis("player_left", "player_right")
	if not (currentAnim == "light_attack_1" or currentAnim == "light_attack_2" or currentAnim == "heavy_attack" or currentAnim == "power") and _IsAlive:
		velocity.x = direction * SPEED * multiplier
	else:
		velocity.x = 0   
	if velocity.x != 0 and PlayerTimer.is_stopped():
		PlayerTimer.start()
	elif velocity.x == 0:
		multiplier = 1.0
		PlayerTimer.stop()
	
	if not is_on_floor():
		if currentAnim == "light_attack_1" or currentAnim == "light_attack_2" or currentAnim == "power" or currentAnim == "heavy_attack":
			velocity.y = gravity * delta * 1.2
		else:
			velocity.y += gravity * delta * 1.8
		if velocity.y > 1200.0:
			velocity.y = 1200.0
	
	if Input.is_action_just_pressed("player_light_attack"):
		if currentAnim == "light_attack_1":
			Animator["parameters/conditions/is_second_attack"] = true
		else:
			StateMachine.travel("light_attack_1")
			Animator["parameters/conditions/is_second_attack"] = false
	
	if Input.is_action_just_pressed("player_heavy_attack"):
		if currentAnim == "heavy_attack":
			return
		StateMachine.travel("heavy_attack")
	
	if Input.is_action_just_pressed("player_magic"):
		if not _CanFreeze:
			return
		if currentAnim == "power":
			return
		StateMachine.travel("power")

	move_and_slide()
	animate()

func animate():
	if velocity.x > 0:
		Sprite.flip_h = false
	elif velocity.x < 0: 
		Sprite.flip_h = true
	
	if velocity == Vector2.ZERO:
		Animator["parameters/conditions/idle"] = true
		Animator["parameters/conditions/is_falling"] = false
		Animator["parameters/conditions/is_jumping"] = false
		Animator["parameters/conditions/is_moving"] = false

	if velocity.y < 0:
		Animator["parameters/conditions/idle"] = false
		Animator["parameters/conditions/is_falling"] = false
		Animator["parameters/conditions/is_jumping"] = true
		Animator["parameters/conditions/is_moving"] = false
		
	elif velocity.y > 0:
		Animator["parameters/conditions/idle"] = false
		Animator["parameters/conditions/is_falling"] = true
		Animator["parameters/conditions/is_jumping"] = false
		Animator["parameters/conditions/is_moving"] = false
		
	if abs(velocity.x) > 0 and is_on_floor():
		Animator["parameters/conditions/idle"] = false
		Animator["parameters/conditions/is_falling"] = false
		Animator["parameters/conditions/is_jumping"] = false
		Animator["parameters/conditions/is_moving"] = true
	
func CreateMagic():
	var totalMagicDamage = MagicAttackDamage * (1 + (3 - getPlayerLevel()) * 0.05) * (1 + _Sanity * 0.25)
	var freezeTime = _Sanity + getPlayerLevel() * 0.5
	var direction = int(not Sprite.flip_h)
	if direction == 0:
		direction = -1
	
	if FreezeCooldown.is_stopped():
		var time = int(10 - _Sanity * 0.5)
		FreezeCooldown.start(time)
		HUD.set_hit(false, time)
		_CanFreeze = false
	
	if MAGIC:
		var magic = MAGIC.instantiate()
		get_tree().current_scene.add_child(magic)
		magic.freeze(freezeTime, totalMagicDamage, Vector2(direction, 0), self.position)

func hurt(value):
	if not _IsAlive:
		return
	var damage = int(value * _MaxHealth * 0.01 * (1 - _Agility * 0.05))
	if value == 1:
		ChangeHealth(-1)
	ChangeHealth(-damage)
	if _IsAlive:
		StateMachine.travel("hit")

	
func ChangeHealth(value):
	if _CurrentHealth + value <= 0:
		if _HasSecondLife:
			_CurrentHealth = 1
			_HasSecondLife = false
		else:
			_CurrentHealth += value
			StateMachine.travel("death")
			_IsAlive = false 
	elif _CurrentHealth + value <= _MaxHealth:
		_CurrentHealth += value
	else:
		_CurrentHealth = _MaxHealth
		_HasSecondLife = true
		
		
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

func _on_weapon_area_body_entered(body):
	if not body.has_method("enemy"):
		return
	
	var type = StateMachine.get_current_node() 
	var damage
	
	if type == "light_attack_1" or type == "light_attack_2":
		damage = LightAttackDamage * (1 + _Agility * 0.05) * (1 + _Power * 0.1)
	elif type == "heavy_attack":
		damage = HeavyAttackDamage * (1 + _Power * 0.3)

	body.hurt(damage)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		$esc_menu.pause()

func _on_freeze_cooldown_timeout():
	_CanFreeze = true

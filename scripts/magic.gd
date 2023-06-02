extends Area2D

const SPEED = 10

var _FreezeDamage
var _FreezeTime
var _Direction

@onready var Animator: AnimationTree = $AnimationTree
@onready var Sprite: AnimatedSprite2D = $Sprite
@onready var StateMachine = Animator.get("parameters/playback")
@onready var MagicTimer: Timer = $Timer

func _ready():
	StateMachine.travel("default")

func freeze(time, damage, direction, player_pos):
	_FreezeTime = time
	_FreezeDamage = damage
	_Direction = direction
	if direction.x == -1:
		Sprite.flip_h = true
		self.position = Vector2(player_pos.x + 170, player_pos.y + 220) 
	else:
		self.position = Vector2(player_pos.x + 250, player_pos.y + 220) 
	
func _physics_process(delta):
	global_position += SPEED * _Direction
	destroy()
	
	
func destroy():
	if StateMachine.get_current_node() == "End":
		self.queue_free()

func _on_timer_timeout():
	StateMachine.travel("destroy")


func _on_body_entered(body):
	if body.has_method("enemy"):
		body.freeze(_FreezeTime, _FreezeDamage)
		StateMachine.travel("destroy") 
		

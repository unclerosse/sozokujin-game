extends ColorRect

@onready var play_button: Button = find_child("Resume")
@onready var quit_button: Button = find_child("Quit")
var flag = 0

func _ready():
	self.visible = false

func unpause():
	flag -= 1
	get_tree().paused = false
	self.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func pause():
	flag += 1
	get_tree().paused = true
	self.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	

func _on_resume_pressed():
	unpause()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


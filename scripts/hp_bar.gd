extends Control

var hp = 100
var max_hp = 100
var val_pow = str(1)
var val_ab = str(1)
var val_s = str(1)
var txt_hp = str(hp)
var txt_max_hp = str(max_hp)

func set_hp(hp,max_hp):
	$hp_bar.value = hp
	$hp_bar.max_value = max_hp
	$hp_bar/Current.text = str(hp) + "/" + str(max_hp)
	$Ab/val_ab.text = val_ab
	$Pow/val_pow.text = val_pow
	$S/val_s.text = val_s
	
func hp_change(hp):
	$hp_bar.value = hp
	$hp_bar/Current.text = txt_hp + "/" + txt_max_hp
	$Ab/val_ab.text = val_ab
	$Pow/val_pow.text = val_pow
	$S/val_s.text = val_s

func _ready():
	set_hp(hp,max_hp)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var text = "FPS: " + str(Engine.get_frames_per_second())
	$FPS.text = text


func _on_hp_bar_value_changed(value):
	hp_change(value)
	pass # Replace with function body.

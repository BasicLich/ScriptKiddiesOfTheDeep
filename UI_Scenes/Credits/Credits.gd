extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		return_to_main_menu()

func return_to_main_menu():
	get_tree().change_scene("res://UI_Scenes/MainMenu/MainMenu.tscn")


func _on_Button_pressed():
	return_to_main_menu()

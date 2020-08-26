extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var pause_popup:Popup

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_popup = find_node('Pause')
	pass # Replace with function body.

func _input(event):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().paused = true
		pause_popup.show()
		
func _on_pause_popup_quit():
	get_tree().paused = false
	get_tree().change_scene("res://UI_Scenes/MainMenu/MainMenu.tscn")
	
func _on_pause_popup_hide():
	get_tree().paused = false
	pause_popup.hide()

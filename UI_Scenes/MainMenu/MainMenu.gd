extends Control


func start_game():
	get_tree().change_scene("res://Game/World/World.tscn")
	
func show_credits():
	get_tree().change_scene("res://UI_Scenes/Credits/Credits.tscn")
	
func quit_game():
	get_tree().quit()




func _on_Credits_pressed():
	show_credits()

func _on_Play_pressed():
	start_game()

func _on_Quit_pressed():
	quit_game()

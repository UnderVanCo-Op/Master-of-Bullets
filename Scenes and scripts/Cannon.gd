extends Node2D

var rock = preload("res://Scenes and scripts/Rock.tscn").instance()

func _input(event):
	if event.is_action_pressed("Shoot"):		# spawn rock
		rock.position = $PositionToSpawn.position
		add_child(rock)
		rock.launch()
		print("shoootiiinggg!!!")

extends Node2D

var rock = preload("res://Scenes and scripts/Rock.tscn").instance()
var spawn_offset := Vector2(100,100)
var rock_speed = 100


func _input(event):
	if event.is_action_pressed("Shoot"):		# spawn rock
#		var impulse := position - get_global_mouse_position()
#		abs(impulse.x)
#		abs(impulse.y)
#		print(impulse)
#		rock.position = position + impulse
		rock.position = $Dulo/SpawnLoc.get_global_position()
		rock.rotation = $Dulo.rotation
		rock.apply_impulse(Vector2(), Vector2(rock_speed,0).rotated($Dulo.rotation))
		get_viewport().get_node("Testworld").add_child(rock)
		#rock.launch(-impulse)
		print("shoootiiinggg!!!")
		#SMain.emit_signal("shoot",  global_position)

func _physics_process(delta):
	$Dulo.look_at(get_global_mouse_position())

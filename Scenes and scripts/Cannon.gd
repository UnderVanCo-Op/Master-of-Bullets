extends Node2D

var rock = preload("res://Scenes and scripts/Rock.tscn").instance()
var spawn_offset := Vector2(100,100)
var rock_speed = 1000

var trajectory : PoolVector2Array

func _input(event):
	if event.is_action_pressed("Shoot"):		# spawn rock
#		var impulse := position - get_global_mouse_position()
#		abs(impulse.x)
#		abs(impulse.y)
#		print(impulse)
#		rock.position = position + impulse
		rock.position = $Dulo/SpawnLoc.get_global_position()
		rock.rotation = $Dulo.get_global_rotation()
		rock.apply_impulse(Vector2(), Vector2(rock_speed,0).rotated($Dulo.rotation))
		get_viewport().get_node("Testworld").add_child(rock)
		#rock.launch(-impulse)
		updatePoints()
		print("shoootiiinggg!!!")
		#SMain.emit_signal("shoot",  global_position)

func _physics_process(delta):
	$Dulo.look_at(get_global_mouse_position())

func _ready():
	#trajectory.append(Vector2(300,300))
	trajectory.append(Vector2(-200,-400))
	trajectory.append($Dulo/SpawnLoc.get_global_position() - global_position)
	print("traj1")
	print(trajectory)
	_draw()

func _draw():
	#draw_line(Vector2(0,0), get_global_mouse_position() - global_position, Color.red, 5)
	draw_polyline(trajectory, Color.red, 5)
	

func updatePoints():	# обновляет точки траектории в соотв-ии с текущим направлением мыши
	for i in trajectory.size() - 1:		# удаление старых точек
		trajectory.remove(i)
	print("traj2")
	print(trajectory)
	trajectory.append($Dulo/SpawnLoc.get_global_position() - global_position)
	trajectory.append(Vector2(-200,-400))
	

# warning-ignore:unused_argument
func _process(delta:float)->void:	
	#updatePoints()	# для обновления точек траектории
	update()		# для обновления встроенной функции _draw
	
	
#func _physics_process(delta):
#	if bounces > 0:
#		rock_pro(delta)
#	else:
#		queue_free()

#func rock_pro(delta):
#	print("HERE2")
#	var remainL = speed * delta
#	var end : Vector2
#	var data : Dictionary
#	trace.append(pos)
#	while remainL > 0.001 && bounces > 0:
#		end = pos + dir * remainL
#		data = get_world_2d().direct_space_state.intersect_ray(pos, end)	# выпускаем луч
#		if data:	# data.position - точка пересечения с коллайдером
#			end = data.position - (data.position - pos).normalized() * 0.01	# смещение точки для выхода из коллайдера
#			dir = dir.bounce(data.normal).normalized()
#			bounces -= 1
#			#data collider
#		remainL -= (end - pos).length()
#		pos = end	# переходим на новую точку
#		trace.append(pos)	# добавить к трейслайну
##

#
#func _draw():
#	print("HERE3")
#	if !trace.empty():
#		for i in trace.size() - 1:	# потому что нужно 2 точки для линии
#			var p1 = trace[i]
#			var p2 = trace[i + 1]
#			draw_line(p1, p2, color1)

#print("HERE")

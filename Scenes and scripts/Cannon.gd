extends Node2D

var rock = preload("res://Scenes and scripts/Rock.tscn").instance()
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
		#updatePoints()
		#print("shoootiiinggg!!!")
		#SMain.emit_signal("shoot",  global_position)

func _physics_process(delta):
	$Dulo.look_at(get_global_mouse_position())
	updatePoints()

func _ready():
	#trajectory.append(Vector2(300,300))
	trajectory.append(Vector2(-200,-400))
	trajectory.append($Dulo/SpawnLoc.get_global_position() - global_position)
	#print("traj1")
	#print(trajectory)
	_draw()

func _draw():
	#draw_line(Vector2(0,0), get_global_mouse_position() - global_position, Color.red, 5)
	
	draw_polyline(trajectory, Color.red, 5)
	

func path_calc():
	var remainL = 50 #2500 # больше явно не понадобится, по факту это коэф-т
	var start = $Dulo/SpawnLoc.get_global_position() - global_position	# позиция дула отн-ая
	var end : Vector2	# вычислим точку до которой будет лететь луч
	end = start + Vector2(remainL, 0).rotated($Dulo.rotation)	# позиция конца отн-ая
	#print("end vector = ")
	#print(end)
	trajectory.append(Vector2(0,0)) 
	#print("start vector = ")
	#print(start)
	trajectory.append(end) 
	var data : Dictionary
	data = get_world_2d().direct_space_state.intersect_ray($Dulo/SpawnLoc.get_global_position(), global_position + end)
	if data:	
		#data.position - точка пересечения с коллайдером
		#end = data.position - (data.position - pos).normalized() * 0.01	# смещение точки для выхода из коллайдера
		#dir = dir.bounce(data.normal).normalized()
		#bounces -= 1
		#data collider
		print("DATA!:")
		print(data)
	else:
		print("NO DATA")
		print(data)
	
	

func updatePoints():	# обновляет точки траектории в соотв-ии с текущим направлением мыши
	for i in trajectory.size() - 1:		# удаление старых точек
		trajectory.remove(i)			# удаление старых точек
	trajectory.remove(0)				# удаление старых точек
	#print("traj2")
	#print(trajectory)
	#print(trajectory.empty())
	path_calc()		# вызов нового просчета пути
	#trajectory.append($Dulo/SpawnLoc.get_global_position() - global_position)	# точка спауна
	#trajectory.append(Vector2(-200,-400)) 
	#trajectory.append(Vector2(500,0).rotated($Dulo.rotation))

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

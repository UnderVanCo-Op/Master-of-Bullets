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
	update()		# для обновления встроенной функции _draw

func _ready():
	pass
	#trajectory.append(Vector2(300,300))
	#trajectory.append(Vector2(-200,-400))
	#trajectory.append($Dulo/SpawnLoc.get_global_position() - global_position)
	#print("traj1")
	#print(trajectory)
	#_draw()

func _draw():
	#draw_line(Vector2(0,0), get_global_mouse_position() - global_position, Color.red, 5)
	draw_polyline(trajectory, Color.red, 5)		# рисует нашу траекторию
	
func traj_minus(v:Vector2):		# добавить в траекторию с вычетом global pos (тк траектория относительная)
	trajectory.append(v - global_position)

func path_calc():
	var bounces = 5
	var remainL = 1000 	#2500 # больше явно не понадобится, по факту это коэф-т
	var start = $Dulo/SpawnLoc.get_global_position()	# позиция дула абс-ая
	var end : Vector2		# вычислим точку до которой будет лететь луч
	var dir : Vector2		# это нормализированный вектор направления
	end = start + Vector2(remainL, 0).rotated($Dulo.rotation)	# позиция конца абс-ая
	dir = end.normalized()
	#print("dir")
	#print(dir)
	#print("end vector = ")
	#print(end)
	traj_minus(start)	# добавить в траекторию с вычетом глобальной позиции
	#print("start vector = ")
	#print(start)
	#trajectory.append(end) 
	var data : Dictionary
	while remainL > 0.001 && bounces >= 0:
		data = get_world_2d().direct_space_state.intersect_ray(start, end)
		if data:	# если есть столкновение
			#data.position - точка пересечения с коллайдером
			end = data.position - (data.position - start).normalized() * 0.01	# смещение точки для выхода из коллайдера
			#end = data.position
			dir = (end - global_position).normalized()
			dir = dir.bounce(data.normal).normalized()
			#data.collider
			#data collider
			print("DATA!:")
			print(data)
			#trajectory.append(data.position - global_position)	# добавить к трейслайну
			pass
		else:
			print("NO DATA")
			print(data)
		remainL -= (end - start).length()
		#print("rL")
		#print(remainL)
		traj_minus(end)
		#trajectory.append(end)
		#print((end - start).length())
		#print((start).length())
		
		#print("traj6")
		#print(trajectory)	
		start = end	# переходим на новую точку
		end = start + remainL * dir
		bounces -= 1
		


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
func _process(delta):	
	pass
	#updatePoints()	# для обновления точек траектории
	#update()		# для обновления встроенной функции _draw
	
	
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

extends Node2D

var rock = preload("res://Scenes and scripts/Rock.tscn").instance()
var rock_speed = 1000	# скорость камня
var isHome := true		# свитчер для камня

var trajectory : PoolVector2Array
var circle := Vector2.ZERO
var circle2 := Vector2.ZERO
var circle3 := Vector2.ZERO

func _input(event):
	if event.is_action_pressed("Shoot"):		# spawn rock
		if isHome:
			rock.position = $Dulo/SpawnLoc.get_global_position()
			rock.rotation = $Dulo.get_global_rotation()
			rock.apply_impulse(Vector2(), Vector2(rock_speed,0).rotated($Dulo.rotation))
			get_viewport().get_node("Testworld").add_child(rock)
			isHome = false
		

func _physics_process(delta):
	$Dulo.look_at(get_global_mouse_position())
	#update()					# для обновления встроенной функции _draw

func traj_to_relative():		# перевод всех коорд, кроме 0-ой в относительные
	for i in trajectory.size():
		trajectory[i] = trajectory[i] - global_position
	#trajectory[0] = trajectory[0] - global_position	# не нужна

func _process(delta):
	calc_traj()

func calc_traj():	# работаем с абс-ми коорд-ами, в конце с помощью ф переводим в отн-ые для ф _draw
	#print(trajectory.size())
	
	print("\n\n\niteration\n")

	trajectory.resize(0)
	
	print("TEST1: trajectory must be empty")
	print(trajectory.size())
	
	var lineLen = 1500 # px or unit of measurment 
	var start = $Dulo/SpawnLoc.get_global_position()	# позиция дула абс-ая
	var end : Vector2			# вычислим точку до которой будет лететь луч (абс)
	var dir : Vector2			# это вектор направления (должен быть нормализированным) 
	#end = start + Vector2(100, 0).rotated($Dulo.rotation)	# позиция конца абс-ая
	end = get_global_mouse_position()				# позиция абс
	dir = end - start
	dir = dir.normalized()		# нормализуем вектор
	#print("dir normalized ".insert(20, var2str(dir)))
	trajectory.append(start)
	end = lineLen * dir + global_position
	
	var spacestate = get_world_2d().direct_space_state
	var data : Dictionary
	data = spacestate.intersect_ray(start, end)
	if data:
		#print("data".insert(20,var2str(data)))
		circle = data.position - global_position	# смещаем circle
		#print("\ndata, pos:")
		#print(data.position)
		#end = data.position
		end = data.position - (data.position - start).normalized() * 0.01
		#print("TEST2: change dir, dir before:".insert(40, var2str(dir)))
		dir = dir.bounce(data.normal).normalized()	# нормалайзд на всякий, вектор правильный
		#print("dir after:".insert(20, var2str(dir)))
		
	else:
		#print("no data")
		lineLen -= (end - start).length()
		trajectory.append(end)
		traj_to_relative()			# переход в относительные коорд-ы
		update()					# обновление функции draw
		return
	
	#while bounces > 0 && lineLen > 0.001:
	#	pass
	#print("\nTEST3: line length, l before: ".insert(50, var2str(lineLen)))
	lineLen -= (end - start).length()
	#print("l after: ".insert(50, var2str(lineLen)))
	
	trajectory.append(end)
	
	############################	2
	
	# updating start and end
	start = end
	end = lineLen * dir + start
	#
	data = spacestate.intersect_ray(start, end)
	if data:
		circle2 = data.position - global_position	# смещаем circle
		#print("some data achieved2")
		end = data.position
		#print("2TEST2: change dir, dir before:".insert(40, var2str(dir)))
		dir = dir.bounce(data.normal).normalized()	# нормалайзд на всякий, вектор правильный
		#print("2dir after:".insert(20, var2str(dir)))
		
	else:
		trajectory.append(end)
		traj_to_relative()			# переход в относительные коорд-ы
		update()					# обновление функции draw
		return
	
	
	#print("\n2TEST3: line length, l before: ".insert(50, var2str(lineLen)))
	lineLen -= (end - start).length()
	trajectory.append(end)
	#print("l after: ".insert(50, var2str(lineLen)))
	
	
	############################	3
	
	# updating start and end
	start = end
	end = lineLen * dir + start
	#
	data = spacestate.intersect_ray(start, end)
	if data:
		#circle3 = data.position - global_position	# смещаем circle
		#print("some data achieved2")
		end = data.position
		#print("2TEST2: change dir, dir before:".insert(40, var2str(dir)))
		dir = dir.bounce(data.normal).normalized()	# нормалайзд на всякий, вектор правильный
		#print("2dir after:".insert(20, var2str(dir)))
		
	else:
		trajectory.append(end)
		traj_to_relative()			# переход в относительные коорд-ы
		update()					# обновление функции draw
		return
	
	
	#print("\n2TEST3: line length, l before: ".insert(50, var2str(lineLen)))
	lineLen -= (end - start).length()
	trajectory.append(end)
	#print("l after: ".insert(50, var2str(lineLen)))
	
	
	
	traj_to_relative()			# переход в относительные коорд-ы
	update()					# обновление функции draw
	
	
	
	



func _draw():	# функция работает относительно
	#draw_line(Vector2(0,0), get_global_mouse_position() - global_position, Color.red, 5)
	#draw_polyline_colors(trajectory, colors, 5)	# рисует нашу траекторию
	draw_polyline(trajectory, Color.red, 5)			# starting point count = 0 so it causes error on play
	draw_circle(circle, 10, Color.greenyellow)
	draw_circle(circle2, 10, Color.blue)
	draw_circle(circle3, 10, Color.fuchsia)
	#print(trajectory)

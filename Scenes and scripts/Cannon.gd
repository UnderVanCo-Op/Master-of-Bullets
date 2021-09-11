extends Node2D

var rock = preload("res://Scenes and scripts/Rock.tscn").instance()
var rock_speed = 1000	# скорость камня
var isHome := true		# свитчер для камня

var trajectory : PoolVector2Array

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

func _process(delta):
	calc_traj()

func traj_to_relative():		# перевод всех коорд, кроме 0-ой в относительные
	for i in trajectory.size():
		trajectory[i] = trajectory[i] - global_position

func calc_traj():	# работаем с абс-ми коорд-ами, в конце с помощью ф переводим в отн-ые для ф _draw
	#print("\n\n\niteration\n")
	trajectory.resize(0)
	
	var lineLen = 1500 # px or unit of measurment 
	var start = $Dulo/SpawnLoc.get_global_position()	# позиция дула абс-ая
	var end : Vector2			# вычислим точку до которой будет лететь луч (абс)
	var dir : Vector2			# это вектор направления (должен быть нормализированным) 
	end = get_global_mouse_position()				# позиция абс
	dir = end - start
	dir = dir.normalized()		# нормализуем вектор
	trajectory.append(start)
	end = lineLen * dir + global_position
	
	var spacestate = get_world_2d().direct_space_state
	var data : Dictionary
	data = spacestate.intersect_ray(start, end)
	
	if data:
		#circle = data.position - global_position	# смещаем circle
		end = data.position - (data.position - start).normalized() * 0.01
		dir = dir.bounce(data.normal.normalized()).normalized()	# нормалайзд для избавления от ошибки
		
	else:
		lineLen -= (end - start).length()
		trajectory.append(end)
		traj_to_relative()			# переход в относительные коорд-ы
		update()					# обновление функции draw
		return
	
	lineLen -= (end - start).length()
	trajectory.append(end)

	while lineLen > 0.1:
		start = end
		end = lineLen * dir + start
		#
		data = spacestate.intersect_ray(start, end)
		if data:
			end = data.position - (data.position - start).normalized() * 0.01
			dir = dir.bounce(data.normal).normalized()	# нормалайзд на всякий, вектор правильный
			
		else:
			trajectory.append(end)
			traj_to_relative()			# переход в относительные коорд-ы
			update()					# обновление функции draw
			return
		
		lineLen -= (end - start).length()
		trajectory.append(end)
		
	traj_to_relative()			# переход в относительные коорд-ы
	update()					# обновление функции draw

#func _draw():	# функция работает относительно
#	draw_polyline(trajectory, Color.gainsboro, 50)			# starting point count = 0 so it causes error on play

func _draw()->void:
	if !trajectory.empty():
		for i in trajectory.size() - 1:
			draw_line(trajectory[i], trajectory[i+1], Color.gainsboro, 20)

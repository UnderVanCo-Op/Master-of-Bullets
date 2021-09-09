extends Node2D

var rock = preload("res://Scenes and scripts/Rock.tscn").instance()
var rock_speed = 1000

var trajectory : PoolVector2Array

func _input(event):
	if event.is_action_pressed("Shoot"):		# spawn rock
		rock.position = $Dulo/SpawnLoc.get_global_position()
		rock.rotation = $Dulo.get_global_rotation()
		rock.apply_impulse(Vector2(), Vector2(rock_speed,0).rotated($Dulo.rotation))
		get_viewport().get_node("Testworld").add_child(rock)
		calc_traj()
		
func _physics_process(delta):
	$Dulo.look_at(get_global_mouse_position())
	#update()					# для обновления встроенной функции _draw


func traj_to_relative():		# перевод всех коорд, кроме 0-ой в относительные
	for i in trajectory.size():
		trajectory[i] = trajectory[i] - global_position
	#trajectory[0] = trajectory[0] - global_position	# не нужна


func calc_traj():	# работаем с абс-ми коорд-ами, в конце с помощью ф переводим в отн-ые для ф _draw
	print(trajectory.size())
	
	for i in trajectory.size() - 1:
		trajectory.remove(i)
	trajectory.remove(0)		# causes error for the first iteration
	
	print("TEST1: trajectory must be empty")
	print(trajectory.size())
	
	var bounces = 1
	var lineLen = 1000 # px or unit of measurment 
	var start = $Dulo/SpawnLoc.get_global_position()	# позиция дула абс-ая
	var end : Vector2			# вычислим точку до которой будет лететь луч (абс)
	var dir : Vector2			# это вектор направления (должен быть нормализированным) 
	#end = start + Vector2(100, 0).rotated($Dulo.rotation)	# позиция конца абс-ая
	end = get_global_mouse_position()				# позиция абс
	dir = end - start
	dir = dir.normalized()		# нормализуем вектор
	print("dir normalized ".insert(20, var2str(dir)))
	var line = lineLen * dir
	
	var spacestate = get_world_2d().direct_space_state
	var data : Dictionary
	data = spacestate.intersect_ray(start, end)
	if data:
		#print("data".insert(20,var2str(data)))
		print("data")
	else:
		print("no data")
	#while bounces > 0 && lineLen > 0.001:
	#	pass
	
	trajectory.append(start)
	trajectory.append(end)
	traj_to_relative()			# переход в относительные коорд-ы
	update()					# обновление функции draw

func _draw():	# функция работает относительно
	#draw_line(Vector2(0,0), get_global_mouse_position() - global_position, Color.red, 5)
	#draw_polyline_colors(trajectory, colors, 5)	# рисует нашу траекторию
	draw_polyline(trajectory, Color.red, 5)			# starting point count = 0 so it causes error on play
	#print(trajectory)

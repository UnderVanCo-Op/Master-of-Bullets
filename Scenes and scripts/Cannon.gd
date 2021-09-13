extends Node2D

var rock : Node2D = preload("res://Scenes and scripts/Rock.tscn").instance()
var rock_speed = 1000	# скорость камня
var isHome := true		# свитчер для камня
var RRadius : float
var LineLengthForRays : int = 500

var trajectory : PoolVector2Array
var circle := Vector2.ZERO
var circle2 := Vector2.ZERO
var circle3 := Vector2.ZERO


func _ready():
	RRadius = rock.get_node("CollisionShape2D").get_shape().radius
	

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
	pass

func traj_to_relative():		# перевод всех коорд, кроме 0-ой в относительные
	for i in trajectory.size():
		trajectory[i] = trajectory[i] - global_position

func calc_traj():	# работаем с абс-ми коорд-ами, в конце с помощью ф переводим в отн-ые для ф _draw
	#print("\n\n\niteration\n")
	trajectory.resize(0)	# очищение предыдущей траектории
	
	var lineLenL = LineLengthForRays			# px or unit of measurment 
	var lineLenR = LineLengthForRays			# px or unit of measurment 
	var start = $Dulo/SpawnLoc.get_global_position()	# позиция дула абс-ая
	var end : Vector2			# вычислим точку до которой будет лететь луч (абс)
	var dir : Vector2			# это вектор направления (должен быть нормализированным) 
	end = get_global_mouse_position()				# позиция абс
	dir = end - start
	dir = dir.normalized()		# нормализуем вектор
	trajectory.append(start)	# добавляем первую точку траектории
	end = lineLenL * dir + global_position
	#
	var Lstart = start + dir.tangent() * RRadius	# правильно
	var Rstart = start + ((dir.tangent()).tangent()).tangent() * RRadius	# правильно
	var Lend = lineLenL * dir + Lstart	# правильно
	var Rend = lineLenR * dir + Rstart	# правильно
#	print("\nTest1")
#	print(end)
#	print(Lend)
#	print(Rend)
	
	#circle2 = Lend - start
	#circle3 = Rend - start
	#circle = end - global_position
	#
	var spacestate = get_world_2d().direct_space_state
	var dataL : Dictionary
	var dataR : Dictionary
	var data : Dictionary
	dataL = spacestate.intersect_ray(Lstart, Lend, [self])
	dataR = spacestate.intersect_ray(Rstart, Rend, [self])
	#data = spacestate.intersect_shape()
	
	if (dataL && dataR):
		if(dataL.position.length() > dataR.position.length()):
			data = dataR
		else:
			data = dataL
	elif (dataL):
		data = dataL
	elif (dataR):
		data = dataR
	else:
		#print("no data on both!")
		#lineLenL -= (end - start).length()
		trajectory.append(end)
		traj_to_relative()			# переход в относительные коорд-ы
		update()					# обновление функции draw
		return
	
	circle = data.position - global_position	# смещаем circle на нашу точку коллизии
	end = data.position - (data.position - start).normalized() * 0.01	# фикс для выхода из коллизии
	dir = dir.bounce(data.normal).normalized()	# нормалайзд на всякий, ошибка когда прицел в платформе начала
	var angle1 = rad2deg(acos(dir.dot(data.normal)))	# 1 - 0 градусов, -1 - 180 градусов; работает корректно, берет меньший из смежных углов
	var angle2 = 90 - angle1	# работаем в градусах
	if(angle1 != 0):
		var MP = abs((RRadius * sin(angle1)) / sin(angle2))		# МБ ОШИБКА из-за непроверки на 0 angle2
		var PC = abs(MP / sin(angle1))# PC - b = CM - искомый отрезок
		var CM = abs((RRadius / sin(angle2)) - ((RRadius * sin(angle1)) / sin(angle2)))	# th sin
#			print("\npart2")
#			print(MP)
#			print(PC)
#			print(CM)
	#var angle3 = 90 - (angle2 / 2)
	#print(angle1)	# корректно
	#print(angle2)	# корректно
	#print(rad2deg(acos(-angle1)))	# вывод
	
	
	#test
	
	#
	
	
	lineLenL -= (end - start).length()
	trajectory.append(end)

#	while lineLen > 0.1:
#		start = end
#		end = lineLen * dir + start
#		#
#		data = spacestate.intersect_ray(start, end)
#		if data:
#			end = data.position - (data.position - start).normalized() * 0.01	# фикс для выхода из коллизии
#			dir = dir.bounce(data.normal).normalized()	# нормалайзд на всякий, вектор правильный
#
#		else:
#			trajectory.append(end)
#			traj_to_relative()			# переход в относительные коорд-ы
#			update()					# обновление функции draw
#			return
#
#		lineLen -= (end - start).length()
#		trajectory.append(end)
		
	traj_to_relative()			# переход в относительные коорд-ы
	update()					# обновление функции draw

#func _draw():	# функция работает относительно
#	draw_polyline(trajectory, Color.gainsboro, 50)			# starting point count = 0 so it causes error on play

func _draw()->void:
	if !trajectory.empty():
		for i in trajectory.size() - 1:
			draw_line(trajectory[i], trajectory[i+1], Color.gainsboro, 20)
		draw_circle(circle, 10, Color.greenyellow)
		draw_circle(circle2, 10, Color.blue)
		draw_circle(circle3, 10, Color.fuchsia)

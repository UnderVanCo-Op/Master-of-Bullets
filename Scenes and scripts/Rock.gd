extends RigidBody2D

export var bounces = 1

var pos : Vector2
var dir : Vector2

var trace : Array
var color1 := Color.white


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

#var dragging
#var drag_start = Vector2()

#func _input(event):
#	if event.is_action_pressed("click") and not dragging:
#		dragging = true
#		drag_start = get_global_mouse_position()
#	if event.is_action_released("click") and dragging:
#		dragging = false
#		var drag_end = get_global_mouse_position()
#		var dir = drag_start - drag_end
#		apply_impulse(Vector2(), dir * 2)

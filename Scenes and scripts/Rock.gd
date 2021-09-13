extends RigidBody2D

#export var bounces = 1
#
#var pos : Vector2
#var dir : Vector2
#
#var trace : Array
#var color1 := Color.white
var Radius : float


func _ready():
	#print($CollisionShape2D.get_global_scale())
	Radius = $CollisionShape2D.get_shape().radius
	#print(Radius)
	#print(transform.basis_xform())
	#print(transform.ba)

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

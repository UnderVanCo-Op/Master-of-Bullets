extends Area2D

const SPEED = 200 # bullet speed
var vel = Vector2() # current velocity


func _physics_process(delta):
	vel.x = SPEED * delta
	translate(vel)


func _on_Bullet_body_entered(body):
	print("hit: ")
	print(body)
	

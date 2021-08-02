extends KinematicBody2D

#state 0 -> dead
#state 1 -> normal
#state 2 -> sick
#state 3 -> recovered

export (int) var state = 1

export (int) var speed = 200

export (int) var redius = 4

export (float) var SickChance = .8

export (float) var deathChance = .03

signal get_sick
signal recovered
signal die

var colors = [
	Color(255,255,255),
	Color(0,255,0) ,
	Color(255,0,0) ,
	Color(0,0,255)
]
var pos = Vector2()
var target = Vector2()


func pick_pos():
	randomize()
	return Vector2(rand_range(0,500),rand_range(0,500))
	pass


# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = rand_range(2,5)
	$Collision.shape.radius  = float(redius)
	$"1m/1mCollision".shape.radius  = float(redius)
	target = pick_pos()
	position = pick_pos()



func _physics_process(delta):
	update()
	pos = position.direction_to(target) * speed
	pos = move_and_slide(pos)

func chance(c):
	if(randf() <= c):
		return true
	return false

func _draw():
	draw_circle(Vector2(0,0),redius,colors[state])


func _on_Timer_timeout():
	target = pick_pos()



func _on_1m_body_entered(body):
	if(body.state == 2 && state == 1):
		if(chance(SickChance)):
			$Recover.start()
			emit_signal("get_sick")
			state = 2


func _on_Recover_timeout():
	if(chance(deathChance)):
		state = 0
		emit_signal("die")
		update()
		set_physics_process(false)
		pass
	else :
		state = 3
		emit_signal("recovered")

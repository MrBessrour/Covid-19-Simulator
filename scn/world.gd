extends Node2D

var human = preload("res://scn/human.tscn")

export (int) var population

export (int) var Initial_Sick_Humans

var days = 1
var sick = 0
var deaths = 0
var Recovered = 0
var Healthy = 0 

var paused = true

func _ready():
	sick = Initial_Sick_Humans
	Healthy = population - Initial_Sick_Humans
	init_text()
	for i in range(population-Initial_Sick_Humans) :
		var h = human.instance()
		h.name = str("human",i+1)
		h.connect("get_sick",self,"sick")
		h.connect("recovered",self,"recovered")
		h.connect("die",self,"die")
		$humans.add_child(h)

	for i in range(population-Initial_Sick_Humans,population) :
		var h = human.instance()
		h.name = str("human",i+1)
		h.state = 2
		h.get_node("Recover").autostart = true
		h.connect("die",self,"die")
		h.connect("get_sick",self,"sick")
		h.connect("recovered",self,"recovered")
		$humans.add_child(h)
	
	get_tree().paused = true



func update_text():
	$output/days.text = str("Day ",days)
	$output/cases.text = str("Sick :",sick)
	$output/Healthy.text = str("Healthy :",Healthy)
	$output/Recovered.text = str("Recovered :",Recovered)
	$output/deaths.text = str("Deaths :",deaths)
	pass

func init_text():
	$output/days.text = str("Day ",days)
	$output/cases.text = str("Sick : ",sick)
	$output/Healthy.text = str("Healthy :",Healthy)
	$output/Recovered.text = str("Recovered :",Recovered)
	$output/deaths.text = str("Deaths :",deaths)
	pass

func sick():
	sick += 1
	Healthy -= 1
	update_text()
	pass


func recovered():
	Recovered += 1
	sick -= 1
	update_text()
	pass

func die():
	deaths += 1
	sick -= 1
	update_text()
	pass

func _on_Days_timeout():
	days += 1 
	update_text()


func _on_start_pressed():
	if(paused):
		get_tree().paused = false
		paused = false
		$start.text = "Pause"
		return

	get_tree().paused = true
	paused = true
	$start.text = "Start"

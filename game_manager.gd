extends Node


var score = 0

func add_point():
	score +=1
	$CanvasLayer/Label.text = str(score)

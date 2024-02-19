extends Control

@onready var score = 5000000.0
@onready var old_score = 0.0
@onready var curr_score = 0.0

func _physics_process(delta):
	spin_score(delta)
	$score_Label.text = str(curr_score)

func spin_score(delta):
	if score > old_score:
		curr_score = lerp(score, old_score, delta*-1000)
	if old_score == score:
		pass

extends Area2D

var player_in_acid = false

func _process(delta):
	if player_in_acid:
		EntityManager.player.add_dot(1)

func _on_AcidPool_body_entered(body):
	if body.get_class() == "Player":
		player_in_acid = true

func _on_AcidPool_body_exited(body):
	if body.get_class() == "Player":
		player_in_acid = false

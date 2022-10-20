extends CPUParticles2D

func create(position):
	self.position = position
	emitting = true

func _process(delta):
	if !emitting:
		queue_free()

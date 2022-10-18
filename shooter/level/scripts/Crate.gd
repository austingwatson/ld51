extends Area2D

export var damage = 0
export var explosion_loops = 0
export var dot = 0
export var explosion_type = 0

func _on_Crate_area_entered(area):
	if area.is_in_group("Projectile"):
		EntityManager.create_explosion(self, damage, dot, explosion_type, explosion_loops)
		queue_free()

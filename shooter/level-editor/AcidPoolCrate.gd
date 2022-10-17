extends StaticBody2D

const acid_pool_scene = preload("res://shooter/level-editor/AcidPool.tscn")

func _on_Area2D_area_entered(area):
	if area.is_in_group("Projectile"):
		var acid_pool = acid_pool_scene.instance()
		acid_pool.position = position
		get_parent().add_child(acid_pool)
		queue_free()

extends Sprite

func _ready():
	$StaticBody2D/CollisionShape2D.shape.extents = Vector2(texture.get_size().x / 2, texture.get_size().y / 2)

extends AnimatedSprite

func _ready():
	var frame = frames.get_frame("default", 0)
	$StaticBody2D/CollisionShape2D.shape.extents = Vector2(frame.get_size().x / 2, frame.get_size().y / 2)


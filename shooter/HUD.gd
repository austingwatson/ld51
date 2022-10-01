extends CanvasLayer

# child nodes
onready var ten_second_timer = $TenSecondTimer

func update_ten_second_timer(time):
	ten_second_timer.text = str(stepify(time, 1))

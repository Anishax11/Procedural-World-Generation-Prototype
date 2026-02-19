extends RichTextLabel

var delay = 0.08
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !visible:
		return
	if delay<=0:
		visible_characters+=1
		delay = 0.05
	else:
		delay-=delta

extends Window

# Multiple Windows 
# https://github.com/geegaz/Multiple-Windows-tutorial

@onready var _Camera: Camera2D = $Camera2D

var last_position: = Vector2i.ZERO
var velocity: = Vector2i.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set Anchor Fixed top-left
	_Camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
	transient = true # Make the window considered as a child of the main window
	close_requested.connect(queue_free) # Actually close the window when clicking the close button

func _process(delta: float) -> void:
	velocity = position - last_position
	last_position = position
	_Camera.position = get_camera_pos_from_window()
	
func get_camera_pos_from_window()->Vector2i:
		return position + velocity

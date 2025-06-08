extends Node2D

@onready var _MainWindow: Window = get_window()
@onready var pet_sprite: AnimatedSprite2D = $Pet/Fawn

# Pet size
var pet_size: Vector2i = Vector2i(64, 64);

# Position and playable area along taskbar
var taskbar_pos: int = (DisplayServer.screen_get_usable_rect().end.y - pet_size.y)
var screen_width: int = (DisplayServer.screen_get_usable_rect().size.x)

# Pet movementexpo
var is_running: bool = false
var direction: int = 1

# Pet speed
const RUN_SPEED = 150

@export_range(0, 19) var player_visibility_layer: int = 1
@export_range(0, 19) var world_visibility_layer: int = 0

func _ready():
	get_tree().get_root().set_transparent_background(true)
	_MainWindow.set_canvas_cull_mask_bit(player_visibility_layer, true)
	
	# Can be set in project settings
	#ProjectSettings.set_setting("display/window/per_pixel_transparency/allowed", true)
	#_MainWindow.borderless = true		# Hide the edges of the window
	#_MainWindow.unresizable = true		# Prevent resizing the window
	#_MainWindow.always_on_top = true	# Force the window always be on top of the screen
	#_MainWindow.gui_embed_subwindows = false # Make subwindows actual system windows <- VERY IMPORTANT
	#_MainWindow.transparent = true		# Allow the window to be transparent
	#_MainWindow.transparent_bg = true	# Make the window's background transparent

	# Change the size of the window
	_MainWindow.min_size = pet_size
	_MainWindow.size = _MainWindow.min_size
	
	# Place pet in the middle of the screen and on top of the taskbar
	_MainWindow.position = Vector2i(screen_width/2 - (pet_size.x/2), taskbar_pos)
	
	print(screen_width)
	print(_MainWindow.position)
	
func _process(delta):
	if is_running:
		run(delta)
	
# Pet boundary
func clamp_on_screen_width(pos, pet_width):
	return clampi(pos, 0, screen_width - pet_width)
	
# Pet movement
func choose_direction():
	if (randi_range(1,2) == 1):
		direction = 1
		pet_sprite.flip_h = false
	else:
		direction = -1
		pet_sprite.flip_h = true
	
func _on_pet_start_run() -> void:
	is_running = true
	choose_direction()

func _on_pet_stop_run() -> void:
	is_running = false

func run(delta):
	# Moves the pet
	_MainWindow.position.x = _MainWindow.position.x + RUN_SPEED * delta * direction
	# Clamps the pet position on the width of screen
	_MainWindow.position.x = clampi(_MainWindow.position.x, 0, clamp_on_screen_width(_MainWindow.position.x, pet_size.x))
	# Changes direction if it hits the sides of the screen
	if ((_MainWindow.position.x == (screen_width - pet_size.x)) or (_MainWindow.position.x == 0)):
		direction = direction * -1
		pet_sprite.flip_h = !pet_sprite.flip_h

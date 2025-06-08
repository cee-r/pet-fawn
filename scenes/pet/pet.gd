extends Node2D

@onready var sprite = $Fawn
@onready var timer = $Timer

var pet_state : int = STATE.IDLE

# signal to change states
signal start_run
signal stop_run

# states
enum STATE {
	IDLE,
	RUN,
}

func _ready():
	pet_state = STATE.IDLE
	sprite.play("idle")
	timer.start()
	print("Start Timer")
	
func change_state():
	pet_state = randi_range(0,1)
	if pet_state == STATE.RUN:
		start_run.emit()

func _on_timer_timeout():
	if pet_state == STATE.RUN:
		stop_run.emit()
		
	await change_state()
	
	match pet_state:
		STATE.IDLE :
			timer.set_wait_time((randi_range(10, 100)))
			sprite.play("idle")
			print(str(timer), " Idle")
		STATE.RUN :
			timer.set_wait_time(randf_range(5,50))
			sprite.play("run")
			print(str(timer), " Run")
	timer.start()

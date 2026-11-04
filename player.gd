extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 3.5
@onready var head: Node3D = $Head
@onready var cam: Camera3D = $Head/Camera3D
@onready var position1: Node3D = $"../position1"
@onready var position2: Node3D = $"../Reality2/position2"
@onready var shiftcooldown: Timer = $shiftcooldown
@onready var anim: AnimationPlayer = $AnimationPlayer

var oncooldown = false
var hasShifted = false
var shiftoffset = 55


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x) * 0.3)
		head.rotation.x -= deg_to_rad(event.relative.y) * 0.3
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-65.0), deg_to_rad(65.0))

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	if Input.is_action_just_pressed("shift") and oncooldown == false:
		if hasShifted == false:
			hasShifted = true
			position.x += shiftoffset
			print("Shifted!")
		else:
			hasShifted = false
			position.x -= shiftoffset
			print("UnShifted!")
		oncooldown = true
		shiftcooldown.start()
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_shiftcooldown_timeout() -> void:
	oncooldown = false

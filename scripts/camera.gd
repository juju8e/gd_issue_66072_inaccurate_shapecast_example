extends Camera3D


@export var target: Node3D
@export var distance: float = 1
@export var sensitivity: float = 1

var yaw: float
var pitch: float


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var look = sensitivity * event.relative;
		yaw -= look.x
		pitch = clampf(fmod(pitch - look.y, 360), -45, 45)


func _process(delta: float) -> void:
	var yaw_rotation = Quaternion(Vector3.UP, deg_to_rad(yaw)).normalized()
	var pitch_rotation = Quaternion(Vector3.RIGHT, deg_to_rad(pitch)).normalized()
	var result_rotation = (yaw_rotation * pitch_rotation).normalized()
	var direction = result_rotation * Vector3.FORWARD

	global_position = target.global_position - distance * direction
	quaternion = result_rotation

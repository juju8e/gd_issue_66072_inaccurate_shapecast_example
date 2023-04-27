extends StaticBody3D


@export var camera: Node3D
@export var speed: float = 4


var velocity: Vector3


func _process(delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (camera.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

		var yaw = atan2(-direction.x, -direction.z)
		quaternion = Quaternion(Vector3.UP, yaw).normalized()
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)


func _physics_process(delta: float) -> void:
	# just move around
	global_position += velocity * delta

	# do motion cast downward
	# output travel vector into console
	var parameters := PhysicsTestMotionParameters3D.new()
	parameters.from = global_transform
	parameters.motion = Vector3.DOWN
	parameters.recovery_as_collision = true
	parameters.collide_separation_ray = true
	# either set recovery_as_collision to true or false
	# same as collide_separation_ray
	# issue still present
	var result := PhysicsTestMotionResult3D.new()
	var hit := PhysicsServer3D.body_test_motion(get_rid(), parameters, result)

	if hit:
		var travel := result.get_travel()
		print(travel)
		# move around for a while and
		# inspect console log to see inconsistency
		# most of the time result is okay
		# but sometimes cast result travel goes too far

		# in the project root look for:
		# "output/console.png" -> console output example
		# "output/reproduce.mov" -> how to reproduced it

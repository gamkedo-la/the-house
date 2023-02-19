extends RayCast

class_name GroundChecker


enum WalkingOn { Unknown, OutsideGround, BuildingGround }


func currently_walking_on() -> int:
	force_raycast_update()
	var collider = get_collider()
	if collider is StaticBody or collider is CSGShape:
		if collider.name == "landscape":
#			print("ground: landscape")
			return WalkingOn.OutsideGround
		else:
#			print("ground: building")
			return WalkingOn.BuildingGround
	else:
#		print("ground: unknown")
		return WalkingOn.Unknown

func collision_distance():
	force_raycast_update()
	if is_colliding():
		var collision_point = get_collision_point()
		return global_transform.origin.distance_to(collision_point)
	else:
		return null
	
	

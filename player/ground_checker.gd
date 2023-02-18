extends RayCast

class_name GroundChecker


enum WalkingOn { Unknown, OutsideGround, BuildingGround }


func currently_walking_on() -> int:
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

extends NavigationRegion3D


# Called when the node enters the scene tree for the first time.
func _ready():
	bake_navigation_mesh(true)

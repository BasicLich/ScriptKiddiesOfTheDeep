extends RigidBody2D

var entity_values := {
	'prop': 0,
	'ballast': 0,
	'trim': 0,
	'debug': 0
}
var entity_descriptions := {
	'prop': ['int [-1 to 100]', 'Propeller.  Source of thrust.  Value of -1 reverses direction of sub.'],
	'ballast': ['int [0 to 4]', 'Ballast setting.  Corresponds to various depth regions.  Ballast value of 0 means an empty ballast.'],
	'trim': ['int [-45 to 45]', 'Adjusts angle of attack of sub.  Negative values will cause sub to drive down, positive values will cause sub to drive up.'],
	'debug': ['boolean [0, 1]', 'Toggles breakpoint in physics process.']
}

var collision:CollisionPolygon2D
var tilemap:TileMap

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	collision=$CollisionPolygon2D
	tilemap=$TileMap


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	position = $RigidBody2D.position + position

func _physics_process(delta):
	#print(rad2deg(linear_velocity.angle()))
	if get_speed() > 0:
		collision.set_scale(Vector2(1,1))
		tilemap.set_scale(Vector2(1,1))
	elif get_speed() < 0:
		collision.set_scale(Vector2(-1,1))
		tilemap.set_scale(Vector2(-1,1))
	
#	if entity_values['prop'] != 0:
#		print(entity_values['prop'], Vector2(entity_values['prop']/100.0 ,0), Vector2(entity_values['prop']/100 ,0).rotated(deg2rad(-entity_values['trim'])))
		
	apply_central_impulse(Vector2(entity_values['prop']/100.0 ,0).rotated(deg2rad(-entity_values['trim'])))
	set_rotation(deg2rad(-entity_values['trim']))
	
	if abs(linear_velocity.length()) < 5 and entity_values['prop'] == 0:
		set_linear_velocity(Vector2(0,0))

func entity_list()->Dictionary:
	return entity_descriptions

func get_entity_value(entity:String):
	return entity_values.get(entity)
	
func get_speed():
	return linear_velocity.length()
	
func set_entity_value(entity:String, value:int)->bool:
	if !entity_values.has(entity):
		return false
		
	if entity=='trim':
		value = max(min(value, 45), -45)
	
	
	entity_values[entity] = value
	return true

extends Node
class_name GameComponent

# Basic component properties
@export var enabled := true
@export var debug_mode := false

# Reference to the parent entity
var entity: Node

# Component lifecycle
func _ready() -> void:
	add_to_group("components")
	entity = get_parent()
	_setup()
	if debug_mode:
		_setup_debug()

func _setup() -> void:
	# Virtual method for component initialization
	pass

func _setup_debug() -> void:
	# Virtual method for debug setup
	pass

# Component update cycle
func _process(delta: float) -> void:
	if enabled:
		_update(delta)
		if debug_mode:
			_debug_update(delta)

func _physics_process(delta: float) -> void:
	if enabled:
		_physics_update(delta)
		if debug_mode:
			_debug_physics_update(delta)

func _update(_delta: float) -> void:
	# Virtual method for frame updates
	pass

func _physics_update(_delta: float) -> void:
	# Virtual method for physics updates
	pass

func _debug_update(_delta: float) -> void:
	# Virtual method for debug frame updates
	pass

func _debug_physics_update(_delta: float) -> void:
	# Virtual method for debug physics updates
	pass

# Component state management
func enable() -> void:
	enabled = true
	_on_enabled()

func disable() -> void:
	enabled = false
	_on_disabled()

func _on_enabled() -> void:
	# Virtual method called when component is enabled
	pass

func _on_disabled() -> void:
	# Virtual method called when component is disabled
	pass

# Component utility methods
func get_sibling_component(component_name: String) -> Node:
	if entity and entity.has_method("get_component"):
		return entity.get_component(component_name)
	return null

func has_sibling_component(component_name: String) -> bool:
	if entity and entity.has_method("has_component"):
		return entity.has_component(component_name)
	return false 
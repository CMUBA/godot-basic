extends Node
class_name Entity

# Dictionary to store component references by type
var components := {}

func _ready():
	# Register all child components
	for child in get_children():
		if child.is_in_group("components"):
			var component_name = child.get_script().get_path().get_file().get_basename()
			components[component_name] = child

func get_component(component_name: String) -> Node:
	return components.get(component_name)

func has_component(component_name: String) -> bool:
	return components.has(component_name)

func add_component(component: Node) -> void:
	if component.is_in_group("components"):
		var component_name = component.get_script().get_path().get_file().get_basename()
		components[component_name] = component
		add_child(component)

func remove_component(component_name: String) -> void:
	if components.has(component_name):
		var component = components[component_name]
		components.erase(component_name)
		remove_child(component)
		component.queue_free() 
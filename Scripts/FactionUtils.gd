class_name FactionUtils

static func make_color_material(color: Color) -> Material:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	return material

static func apply_faction_colors(faction: Faction, node: Node):
	if node is MeshInstance3D:
		var mesh_instance = node as MeshInstance3D
		if mesh_instance.mesh.get_surface_count() == 4:
			# TODO: cache materials here
			print("Applying faction colors to " + mesh_instance.name)
			mesh_instance.set_surface_override_material(0, make_color_material(faction.base_color))
			mesh_instance.set_surface_override_material(1, make_color_material(faction.highlight_color))
			mesh_instance.set_surface_override_material(2, make_color_material(faction.dark_color))
			mesh_instance.set_surface_override_material(3, make_color_material(faction.darkest_color))
	
	for child_node in node.get_children():
		apply_faction_colors(faction, child_node)

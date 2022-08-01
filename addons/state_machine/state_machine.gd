tool
extends EditorPlugin

signal visibility_changed(value)
signal machine_selected(object)

var dock : Node = null

func _enter_tree() -> void:
	var template_file_dir := "res://addons/state_machine/script_templates/state_template.gd"
	var templates_path_dir : String = ProjectSettings.get_setting("editor/script_templates_search_path")
	preparing_folders(templates_path_dir, template_file_dir)
	
	dock = preload("dock/dock.tscn").instance()
	dock.script_editor = get_script_create_dialog()
	dock.interface_editor = get_editor_interface()
	dock.tool_button = add_control_to_bottom_panel(dock, "State Machine")
	
	connect("visibility_changed", dock, "_on_visibility_changed")
	connect("machine_selected", dock, "_on_machine_selected")
	
	make_visible(false)
	
	get_script_create_dialog().connect("script_created", dock, "attach_script")


func _exit_tree() -> void:
	if is_instance_valid(dock):
		remove_control_from_bottom_panel(dock)
		dock.queue_free()


func _ready() -> void:
	yield(get_tree(), 'idle_frame')
	dock.rect_min_size.y = get_editor_interface().get_editor_viewport().rect_size.y * 0.49


func preparing_folders(dir_path: String, file_path: String) -> void:
	var dir = Directory.new()
	if not dir.dir_exists(dir_path):
		if dir.make_dir(dir_path) != OK:
			print_debug("[ERROR] - Can't make '%s' folder" % dir_path)
	
	var new_path := dir_path + "/state_template.gd"
	if not dir.file_exists(new_path):
		if dir.copy(file_path, new_path) != OK:
			print_debug("[ERROR] - Can't copy '%s' file to %s" % [file_path, new_path])


# --- Virtual Functions --- #

func handles(object: Object) -> bool:
	var condition := object is StateMachine
	if condition:
		emit_signal("machine_selected", object)
	return condition


func make_visible(visible: bool) -> void:
	emit_signal("visibility_changed", visible)

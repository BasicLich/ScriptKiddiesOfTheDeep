extends Control
const Util = preload('res://Util.gd')
const Console_Out = preload('res://Data_Types/Console_Out.gd')



var console_input:LineEdit
var console_display:RichTextLabel
var debug_label:Label
var color_default:Color
export var color_error:Color
export var color_text_entered:Color
export var color_text_default:Color
var Player:Node
var Cam:Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Player=find_parent('World').find_node('Ship')
	Cam=find_parent('World').find_node('Camera2D')
	console_display = find_node('RichTextLabel')
	console_input = find_node('TextEdit')
	debug_label = $Label
	
	
	color_default = console_input.get_color("font_color")
	
	parse('help')
	
func _physics_process(delta):
	if Player.get_entity_value('debug'):
		print('Debugging')
		
		
func _process(delta):
	console_input.grab_focus()
	debug_label.set_text('Speed: %s'%Player.get_speed())
	
	
	
func _input(event):
	if event is InputEventKey and Input.is_action_just_pressed("gm_AcceptText"):
		parse(console_input.get_text())
		clear_entry()
	
	
func parse(s:String):
	console_display_msg(Console_Out.new('> %s' % s, Console_Out.ENTERED))	
	var commands = s.split(';')
	for command in commands:
		parse_command(command.trim_suffix(" ").trim_prefix(" "))

func parse_command(s:String):
	var tokens = s.split(' ')
	var out:Console_Out
	
	match tokens[0]:
		'help':
			out=cmd_help(tokens)
		'set':
			out=cmd_set(tokens)
		'get':
			out=cmd_get(tokens)
		'list':
			out=cmd_list(tokens)
		'desc':
			out=cmd_desc(tokens)
		_:
			out=Console_Out.new('Command \'%s\' not recognized' % tokens[0], Console_Out.ERROR)
			
	console_display_msg(out)
	
	return true
	
func cmd_get(tokens:Array):
	if len(tokens) < 2:
		return Console_Out.new('You need at least one argument for the set command.  Acceptable format is `get <entity>`.', Console_Out.ERROR)
		
	var out := Console_Out.new([])
	for k in range(1, len(tokens)):
		var value = Player.get_entity_value(tokens[k])
		if value == null:
			return Console_Out.new('The entity \'%s\' does not exist.  Please use the `list` command to view available entities.' % tokens[k], Console_Out.ERROR)
		else:
			out.add_line('%s: %s' % [tokens[k], value])
			
	return out
	
func cmd_help(tokens:Array):
	var out := Console_Out.new([], Console_Out.OUTPUT)
	if len(tokens) < 2:
		# general help
		out.add_line(
			'help\n'+
			'	shows this help menu\n'+
			'help <command>\n'+
			'	shows the help page for a given command\n'+
			'\n'+
			'Available commands:\n'+
			'* set - sets an entity\'s value\n'+
			'* get - gets the value of an entity\n'+
			'* list - lists avaliable entities and accepted values\n'+
			'* desc - describes an entity'
		)
	else:
		match tokens[1]:
			'set':
				out.add_line(
					'set <entity>=<value>\n'+
					'set <e1>=<v1> <e2>=<v2> {...}\n'+
					'	Set the value of one or more entities. Examples:\n'+
					'* set e1=50\n'+
					'	sets the value of engine 1 to 50%'
				)
			'list':
				out.add_line(
					'list\n'+
					'	Lists avaliable entities and accepted values'
				)
			'desc':
				out.add_line(
					'desc <entity>\n'+
					'	Describes an entity and provides information about acceptable values'
				)
			'get':
				out.add_line(
					'get <entity>\n'+
					'	Gets the current value for a given entity'
				)
			_:
				out = Console_Out.new('not implemented')
	
	return out
	
func cmd_set(tokens:Array):
	var out:Console_Out
	var set_phrase:Array
	var set_vals := []
	
	print(Util.array_str(tokens))
		
	if len(tokens) < 2:
		# error, need more arguments
		return Console_Out.new('You need at least one argument for the set command.  Acceptable format is `set <entity>=<value>`.', Console_Out.ERROR)
	else:
		var entities = Player.entity_list()
		
		for k in range(1,len(tokens)):
			set_phrase = tokens[k].split('=')
			
			if len(set_phrase) < 2 or len(set_phrase[1]) < 1:
				# error, need more parts to the command
				return Console_Out.new('You need both a target and a value for the set command.  Format should be `set <entity>=<value>`.', Console_Out.ERROR)
			elif !entities.has(set_phrase[0]):
				return Console_Out.new('Entity %s does not exist.  Please use the `list` command to view available entities.' % set_phrase[0], Console_Out.ERROR)
			else:
				set_vals.append(set_phrase)
				
		out = Console_Out.new([])
		print(set_vals)
		
		for k in range(len(set_vals)):
			Player.set_entity_value(set_vals[k][0], int(set_vals[k][1]))
			out.add_line('Set %s to value %s' % [set_vals[k][0], set_vals[k][1]])
	
	return out
	
func cmd_list(tokens:Array):
	var entities:Dictionary = Player.entity_list()
	var out := Console_Out.new([])
	
	for entity in entities:
		out.add_line('%s: %s' % [entity, entities[entity][0]])
	
	return out
	
func cmd_desc(tokens:Array):
	var entities:Dictionary = Player.entity_list()
	
	if len(tokens) < 2:
		return Console_Out.new('You need at least one argument for the set command.  Acceptable format is `desc <entity>`.', Console_Out.ERROR)
	for k in range(1,len(tokens)):
		if !entities.has(tokens[k]):
			return Console_Out.new('Entity \'%s\' does not exist.  Please use the `list` command to view available entities.' % tokens[1], Console_Out.ERROR)
	
	var out := Console_Out.new([])
	
	for k in range(1,len(tokens)):
		out.add_line(
			'%s: %s\n\t%s' % [tokens[k], entities[tokens[k]][0], entities[tokens[k]][1]]
		)
	
	return out
	
	
func console_display_msg(msg:Console_Out):
	for message in msg.output:
		if msg.type == Console_Out.ERROR:
			console_display.push_color(color_error)
			message = '[ERROR] ' + message
		elif msg.type == Console_Out.ENTERED:
			console_display.push_color(color_text_entered)
		else:
			console_display.push_color(color_text_default)
		
		console_display.add_text(message)
		console_display.newline()
		console_display.newline()
		
func clear_entry():
	console_input.set_text("")


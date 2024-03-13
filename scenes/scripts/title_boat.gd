extends Node2D

@onready var rod = $Rod
@onready var rod_2 = $Rod2
@onready var rod_3 = $Rod3
@onready var rod_4 = $Rod4

var timer: float = 3.0
var last_catch: int

# Called when the node enters the scene tree for the first time.
func _ready():
	rod.get_node("SkeleSprites").apply_scale(Vector2(-1, 1))
	#rod
	rod_2.apply_scale(Vector2(-1, 1))
	
	rod.get_node("AnimationPlayer").play('idle')
	await get_tree().create_timer(randf_range(.2, 1.0)).timeout
	rod_2.get_node("AnimationPlayer").play('idle')
	await get_tree().create_timer(randf_range(.2, 1.0)).timeout
	rod_3.get_node("AnimationPlayer").play('idle')
	await get_tree().create_timer(randf_range(.2, 1.0)).timeout
	rod_4.get_node("AnimationPlayer").play('idle')
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(timer <= 0):
		var rdm = randf()
		if(rdm <= .25): 
			rod.get_node("AnimationPlayer").play('catch')
			get_tree().create_timer( randf_range(3.0, 7.0) ).timeout.connect( func(): reset_rod(1) )
		elif(rdm <= .50): 
			rod_2.get_node("AnimationPlayer").play('catch')
			get_tree().create_timer( randf_range(3.0, 7.0) ).timeout.connect( func(): reset_rod(2) )
		elif(rdm <= .75): 
			rod_3.get_node("AnimationPlayer").play('catch')
			get_tree().create_timer( randf_range(3.0, 7.0) ).timeout.connect( func(): reset_rod(3) )
		elif(rdm <= 1.0): 
			rod_4.get_node("AnimationPlayer").play('catch')
			get_tree().create_timer( randf_range(3.0, 7.0) ).timeout.connect( func(): reset_rod(4) )
		
		timer = randf_range(3.0, 7.0)
		
	timer -= delta
			
func reset_rod(rodn: int):
	if(rodn == 1): rod.get_node("AnimationPlayer").play('idle')
	elif(rodn == 2): rod_2.get_node("AnimationPlayer").play('idle')
	elif(rodn == 3): rod_3.get_node("AnimationPlayer").play('idle')
	elif(rodn == 4): rod_4.get_node("AnimationPlayer").play('idle')

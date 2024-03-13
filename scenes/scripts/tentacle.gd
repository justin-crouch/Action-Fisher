extends Area2D

@onready var INTERACT = $Interact
@onready var animation_player = $AnimationPlayer
@onready var parts = $SkeleParts/Parts
@onready var skele_parts = $SkeleParts
@onready var attack = $Attack
@onready var hurt = $Hurt
@onready var emerge_1 = $Emerge1
@onready var emerge_2 = $Emerge2
@onready var emerge_3 = $Emerge3

var rdm_noise

@export_node_path('Node2D') var TARGET_POS
@export_node_path("Node2D") var BOAT_PATH
var Boat

@export_enum('TRUE:0', 'FALSE:2') var FLIP: int = 2
@export_range(1.0, 30.0) var MIN_COOLDOWN_TIME: float 	= 5.0
@export_range(1.0, 30.0) var MAX_COOLDOWN_TIME: float 	= 5.0
@export_range(0.1, 3.0) var HIT_COOLDOWN: float = 1.0
@export var MAX_HITS: int 						= 3
@export_range(0.1, 10.0) var ATK_COOLDOWN: float = 3.0
@export_range(1, 50) var MAX_ATK: int = 30

var atk_dmg: int = 1
var cooldown_timer

var start_pos
var nearby: bool = false
var hits: int = MAX_HITS
var hurt_timer: float = HIT_COOLDOWN
var atk_timer: float = ATK_COOLDOWN

enum STATES {
	WAIT,
	WAITING,
	
	ATTACK,
	ATTACKING,
	
	HURT,
	HURTING,
	
	RETREAT,
	RETREATING,
	INACTIVE,
}
var state: STATES

# Called when the node enters the scene tree for the first time.
func _ready():
	rdm_noise = [emerge_1, emerge_2 ,emerge_3]
	skele_parts.scale = Vector2(FLIP-1, 1)
	reset_color()
	animation_player.play_backwards("appear")
	
	Boat = get_node(BOAT_PATH)
	start_pos = global_position
	state = STATES.INACTIVE
	
	Score.on_pause.connect(func(paused): if(paused): animation_player.pause() else: animation_player.play())
	
	cooldown_timer = randf_range(MIN_COOLDOWN_TIME, MAX_COOLDOWN_TIME)
	Boat.tick.connect(_on_tick)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_tick(delta, game_time):
	atk_dmg = lerp( 1, MAX_ATK, clamp(Boat.get_time(), 0, 120)/120 )
	
	match(state):
		STATES.WAIT:
			global_position = start_pos
			cooldown_timer = randf_range(MIN_COOLDOWN_TIME, MAX_COOLDOWN_TIME)
			INTERACT.visible = false
			state = STATES.WAITING
			
		STATES.WAITING:
			if(cooldown_timer <= 0): state = STATES.ATTACK
			cooldown_timer -= delta
			
		STATES.ATTACK:
			state = STATES.INACTIVE
			hits = MAX_HITS
			atk_timer = lerp( 1.5, ATK_COOLDOWN, Boat.rods / 4.0 )
			
			
			animation_player.play("appear")
			animation_player.queue("idle")
			
			var tween = get_tree().create_tween()
			tween.tween_property($".", 'global_position', get_node(TARGET_POS).global_position, .5)
			await tween.finished
			
			if(randf() < .3): rdm_noise.pick_random().play()
			reset_color()
			
			state = STATES.ATTACKING 
			
		STATES.ATTACKING:
			if(nearby): INTERACT.visible = true
			else: 		INTERACT.visible = false
			
			atk_timer -= delta
			if(atk_timer <= 0):
				attack.play()
				animation_player.play("attack")
				animation_player.queue("idle")
				
				Boat.damage( round( atk_dmg ) )
				atk_timer = lerp( 1.5, ATK_COOLDOWN, Boat.rods / 4.0 )
			
			if(nearby && Input.is_action_just_pressed("ATTACK")):
				atk_timer = lerp( 1.5, ATK_COOLDOWN, Boat.rods / 4.0 )
				hits -= 1
				hurt_timer = HIT_COOLDOWN
				state = STATES.HURT
			
		STATES.HURT:
			hurt.play()
			animation_player.play("hurt")
			animation_player.queue("idle")
			state = STATES.HURTING
			
			await get_tree().create_timer(HIT_COOLDOWN).timeout
			reset_color()
			
			if(hits <= 0): state = STATES.RETREAT
			else: state = STATES.ATTACKING
			
		STATES.RETREAT:
			state = STATES.RETREATING
			INTERACT.visible = false
			
			reset_color()
			
			if(randf() < .3): rdm_noise.pick_random().play()
			
			animation_player.speed_scale = .8
			animation_player.play_backwards("appear")
			await get_tree().create_timer(.5).timeout
			
			var tween = get_tree().create_tween()
			tween.tween_property($".", 'global_position', start_pos, 2.0)
			await tween.finished
			
			animation_player.stop()
			animation_player.speed_scale = 1
			#global_position = start_pos
			state = STATES.WAIT
			

func _on_body_entered(body):
	if(body.name != 'Player'): return
	nearby = true


func _on_body_exited(body):
	if(body.name != 'Player'): return
	nearby = false


func reset_color():
	for c in parts.get_children():
		c.modulate = Color(1.0, 1.0, 1.0, 1.0)

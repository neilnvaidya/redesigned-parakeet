extends CharacterBody2D


enum State {
    Idle, Move, Shoot, Charge, Wake, Death, Init
}

var current_state : State = State.Init

var move_vector : Vector2 = Vector2.ZERO
var facing : float = 1 :
    set(val):
        facing = val
        if facing < 0:
            body_sprite.flip_h = true
            fx_sprite.flip_h = true
        else: 
            body_sprite.flip_h = false
            fx_sprite.flip_h = false
        fx_sprite.position.x =facing*42
        
var grounded :bool  = true
@onready var readout = $readout
@onready var anim_player = $AnimationPlayer
@onready var body_sprite = $BodySprite
@onready var fx_sprite = $FxSprite
var epsilon = 0.1
var move_speed : float = 200
var aim_vector :Vector2 =Vector2.ZERO
var bullet_count: int = 3
var try_shoot :bool = false
@onready var bullet_prefab = preload("res://bullet.tscn")
@onready var bullet_container = get_node("/root/Map/bullets")
var health = 3
const start_position = Vector2(300,600)

signal announce_position_signal(pos)
signal bullet_used
signal bullet_collected
signal health_lost
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
func _physics_process(delta):
    on_state_tick(current_state, delta)

func set_state(new_state):
    if current_state != null:
        on_state_exit(current_state)
    
    current_state = new_state    
    on_state_enter(new_state)
    
func on_state_enter(new_state):
    print("Player Enter: " , State.keys()[new_state])
    if new_state == State.Wake:
        anim_player.play("wake")
    
    if new_state == State.Move:
        anim_player.play("move")
    
    if new_state == State.Charge:
        anim_player.play("charge")
        try_shoot = false
        
    if new_state == State.Shoot:
        anim_player.play("shoot")
        var bullet = bullet_prefab.instantiate()
        bullet_container.add_child(bullet)
        bullet_count -=1 
        bullet.position += position + Vector2(42*facing,-6)
        bullet.facing = facing
        print(bullet_count)
        bullet_used.emit()
        
    if new_state == State.Idle:
        anim_player.play("idle")
    
func on_state_exit(state):
    pass

func can_shoot(state) -> bool:
    return (state == State.Idle || state == State.Move) && bullet_count > 0
   
    
func on_state_tick(state, delta):
    if health <=0:
        print("DEATH!!!")
        
    announce_position_signal.emit(position)
    aim_vector = get_viewport().get_mouse_position() - global_position
    
    #readout.text = str(move_vector) + "\n" + str(aim_vector)+ "\n" + str(global_position)+"\n" + str(facing)
    grounded=  is_on_floor()
    
    if state==null:
        set_state(State.Init)
        return
        
    if state == State.Init:
        set_state(State.Wake)
        return
    
    if can_shoot(state) && try_shoot:
        set_state(State.Charge)
        return
        
    if state == State.Idle:
        if move_vector.length() > epsilon:
            set_state(State.Move)
            return
            
    if state == State.Move:
        facing = sign(aim_vector.x)
        if move_vector.length() > epsilon:  
            velocity = move_vector*move_speed
            move_and_slide()
        else: set_state(State.Idle)
        
        return
    
    
    
func _input(event):
    move_vector = Input.get_vector("move_left","move_right","move_up","move_down")
    
    if event is InputEventMouseButton:
        if event.pressed:
            try_shoot = true

func _on_animation_player_animation_finished(anim_name):
    if anim_name == "wake":
        set_state(State.Idle)
    if anim_name == "charge":
        set_state(State.Shoot)
    if anim_name == "shoot":
        set_state(State.Idle)

func collect_bullet():
    print("collecting")
    bullet_count +=1
    bullet_collected.emit()

func take_damage():
    print("taking damage")
    health -=1
    health_lost.emit()

func on_reset():
    position = start_position
    set_state(State.Init)
    health = 3
    bullet_count = 3
    visible = true
    try_shoot = false
    


func _on_canvas_layer_reset_game():
    on_reset()

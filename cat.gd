extends CharacterBody2D


var player_position : Vector2 = Vector2.ZERO
var move_speed = 75
var target_dir :Vector2 = Vector2.ZERO

func _physics_process(delta):
    target_dir = (player_position - position).normalized()
    velocity = target_dir*move_speed
    var collision  = move_and_collide(velocity * delta)
    if collision:
        var collider = collision.get_collider()
        if collider.is_in_group("Player"):
            collider.take_damage()            
            on_player_contact()
    
func on_hit():
    queue_free()

func on_player_contact():
    queue_free()
    
    

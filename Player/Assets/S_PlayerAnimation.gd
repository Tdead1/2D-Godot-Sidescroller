extends Spatial

var animplayer : AnimationPlayer;
var parent : RigidBody;

export var walkspeedratio = 0.15; 
var xvelocity = 0.0;

enum JumpState {
	GROUNDED = 0,
	JUMPING = 1,
	FALLING = 0	
}


func _ready():
	parent = get_parent();
	animplayer = get_node("AnimationPlayer");
	animplayer.get_animation("ANIM_Run").set_loop(true);
	animplayer.get_animation("ANIM_Idle").set_loop(true);
	animplayer.play("ANIM_Idle");
	pass

func _process(delta):
	#rotate smoothly.
	xvelocity += parent.velocity.x * 0.03;
	xvelocity = clamp(xvelocity, -1.4, 1.4);
	set_rotation(Vector3(0.0, xvelocity, 0.0));
			
	# Set animations
	if(!parent.sliding):	
		if(abs(parent.inputwalk) > 0.0):
			if(animplayer.current_animation != "ANIM_Run"):
				animplayer.play("ANIM_Run");
		elif(animplayer.current_animation != "ANIM_Idle"):
			animplayer.play("ANIM_Idle");
	elif(animplayer.current_animation != "ANIM_Slide"):
		animplayer.play("ANIM_Slide");
		
	# Set playback speed
	if(animplayer.current_animation == "ANIM_Run"):
		animplayer.playback_speed = 1.5;#abs(parent.velocity.x) * walkspeedratio;
	else:
		animplayer.playback_speed = 1.0;
		
#	if(!parent.sliding):
#		if(abs(parent.velocity.x) > 0.5):
#			animplayer.playback_speed = abs(parent.velocity.x) / walkspeedratio;
#			if(animplayer.current_animation != "ANIM_Run"):
#				animplayer.play("ANIM_Run");
#		else:
#			if(animplayer.current_animation != "ANIM_Idle"):
#				animplayer.playback_speed = 1.0;
#				animplayer.play("ANIM_Idle");
#	else:
#		animplayer.playback_speed = 1.0;
#		animplayer.play("ANIM_Slide");		
	pass;



#include "../backend/float.as"

entity vanta;

[start]
void start()
{
	//temporary
	set_position(get_player(), vec(4.5, 10));
	set_direction(get_player(), direction::up);
	//set_position(get_player(), vec(4.5, 19));
	
	entity tDarkness = add_entity("dark_texture", "darkness");
	set_position(tDarkness, vec(4.5, 21));
	set_depth(tDarkness, 0);
}

[start]
void create_vanta()
{
	vanta = add_entity("vanta", "default:default");
	set_position(vanta, vec(4.5, 2.5));
	set_depth(vanta, 1);
	start_animation(vanta);
	
	do{
		float_entity(vanta, 0.3, 1);
	}while(yield());
}

void create_window(vec pPosition)
{
	//windows will be animated later
	entity window1 = add_entity("window", "rain");
	set_position(window1, pPosition);
	set_depth(window1, fixed_depth::below);
	start_animation(window1);
}

[start]
void create_windows()
{
	create_window(vec(3.5, 2));
	create_window(vec(5.5, 2));
}

entity create_lightning(vec pPosition)
{
	entity wLight = add_entity("window_lightning_short", "flash");
	set_position(wLight, pPosition);
	set_depth(wLight, fixed_depth::overlay);
	return wLight;
}

/*[start]
void animate_lightning()
{
	entity leftLight  = create_lightning(vec(3.5, 2));
	entity rightLight = create_lightning(vec(5.5, 2));
	
	start_animation(leftLight);
	start_animation(rightLight);
	
}*/

[start]
void do_lightning() {
  entity leftLight  = create_lightning(vec(3.5, 2));
	entity rightLight = create_lightning(vec(5.5, 2));
  
  float t;
  float r;
  
  do {
    
    t = random(5, 17);
    
    wait(t);
    
    stop_animation(leftLight);
    stop_animation(rightLight);
    
    dprint(formatFloat(t));
    start_animation(leftLight);
    start_animation(rightLight);
    
    r = random(2, 17);
    
    if(r < 4) {
      wait(r * .5);
      dprint(formatFloat(r));
      stop_animation(leftLight);
      stop_animation(rightLight);
      
      start_animation(leftLight);
      start_animation(rightLight);
    }
    
  } while(yield());
}

void create_column(vec pPosition)
{
	entity column1 = add_entity("dungeon","pillar");
	set_position(column1, pPosition);
}

[start]
void create_columns()
{
	create_column(vec(2.5, 6.75));
    create_column(vec(6.5, 6.75));
	create_column(vec(2.5, 8.75));
	create_column(vec(6.5, 8.75));
}

entity create_darkness(vec pPosition)
{
	entity darkness = add_entity("dark_light_up", "dark");
	set_position(darkness, pPosition);
	set_depth(darkness, 0);
	return darkness;
}

entity create_torch(vec pPosition)
{
	entity torch = add_entity("torch", "torch");
	set_position(torch, pPosition);
	return torch;
}

class pair
{
	entity left;
	entity right;
};

array<pair> torches(3);
array<pair> darks(3);

[start]
void create_torches()
{
	for(int k = 0; k < 3; k++)
	{
		torches[k].left = create_torch(vec(3.5, (k*2) + 11));
		torches[k].right = create_torch(vec(5.5, (k*2) + 11));
		darks[k].left = create_darkness(vec(3.5, (k*2) + 11));
		darks[k].right = create_darkness(vec(5.5, (k*2) + 11));
	}
	
	entity left_torch   = create_torch(vec(2.5, 3.5));
	entity right_torch = create_torch(vec(6.5, 3.5)); 
	entity left_dark = create_darkness(vec(2.5, 3.5));
	entity right_dark = create_darkness(vec(6.5, 3.5)); 
	
	set_atlas(left_torch, "light");
	set_atlas(right_torch, "light");
	set_atlas(left_dark, "flicker");
	set_atlas(right_dark, "flicker");
	
	start_animation(left_torch);
	start_animation(right_torch);
	start_animation(left_dark);
	start_animation(right_dark);
	
	set_depth_fixed(left_torch, false);
	set_depth_fixed(right_torch, false);
}

void light_torch(int k)
{
	player::lock(true);
	set_atlas(torches[k].left, "ignite");
	set_atlas(torches[k].right, "ignite");
	
	set_atlas(darks[k].left, "light");
	set_atlas(darks[k].right, "light");
	
	start_animation(torches[k].left);
	start_animation(torches[k].right);
	
	start_animation(darks[k].left);
	start_animation(darks[k].right);
	
	wait(0.80);
	
	player::lock(false);
}

void animate_torch(int k)
{
	set_atlas(torches[k].left, "light");
	set_atlas(torches[k].right, "light");
	
	set_atlas(darks[k].left, "flicker");
	set_atlas(darks[k].right, "flicker");
				
	start_animation(torches[k].left);
	start_animation(torches[k].right);
	
	start_animation(darks[k].left);
	start_animation(darks[k].right);
}

[group step2]
void light_torch2()
{
	light_torch(2);
	animate_torch(2);
	
	once_flag("torch2");
	
}

[group step1]
void light_torch1()
{
	light_torch(1);
	animate_torch(1);
	
	once_flag("torch1");
}

[group step0]
void light_torch0()
{
	light_torch(0);
	animate_torch(0);
	
	once_flag("torch0");
}

[group vanta]
void vanta_black()
{
	once_flag("potatoes");
	player::lock(true);
	
	wait(1);
	start_animation(get_player());
	pathfind_move(get_player(), vec(4.5, 5), 1.5, 0);
	stop_animation(get_player());
	set_direction(get_player(), direction::up);
	
	wait(1);
	
	//initial sprite of vanta is of them sitting on the throne
	focus::move(get_position(vanta), 2);
	
	narrative::set_speaker(vanta);
	set_atlas(vanta, "talk");
	say("Hello.");
	say("I've waited very long for \nyou to arrive.");
	
	narrative::clear_speakers();
	narrative::set_speed(1);
	fsay("\n...");
	
	wait(1);
	
	narrative::set_interval(30);
	narrative::set_speaker(vanta);
	//set_atlas(vanta, "talk_squint");
	fsay("Why the incredulous look, \nchild?");
	
	wait(2);
	
	say("Do you not remember me?");
	int opt = select("I remember you!", "Who are you?");
	if(opt == 0)
	{
		set_flag("remembered"); 
		//set expression to calm 
		//set_atlas(vanta, "talk_happy");
		fsay("Yes, yes. Of course you do.");
		wait(0.5);
	}
	else if(opt == 1)
	{
		set_flag("forgotten");
		//set expression to annoyed
		//set_atlas(vanta, "talk_sinister");
		fsay("Don't play the fool, \nignorant child!");
		wait(0.25);
	}
	//set_atlas(vanta, "talk_squint");
	say("Everyone in the Void knows \nof me.");
	say("For it is I...");
	//Vanta approaches player, change sprite animation
	move(vanta, vec(4.5, 3.75), 1);
	//set_atlas(vanta, "talk_sinister");
	fsay("THE GREAT");
	wait(1);
	move(vanta, vec(4.5, 4), 0.75);
	//thunder and lightning; make sure to show lightning first then thunder
	fsay("VANTA");
	wait(0.5);
	move(vanta, vec(4.5, 4.5), 0.50);
	wait(0.5);
	say("BLACK!");
	//more thunder+lightning and battle commence
	wait(2);
	say("By the way, I'm cosplaying \nas Spoopy-senpai");
	say("SPOOPY-SENPAI, PLEASE \nNOTICE ME!");
	
	narrative::end();
	
	player::lock(false);
	
	focus::move(get_position(get_player()), 1);
	focus::player();
	/*
	also add expressions in narrative box
	
	*/
	
}


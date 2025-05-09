card = noone;

function Update()
{
	if (position_meeting(mouse_x, mouse_y, id))
	{
		image_xscale = 2;
		image_yscale = 2;
		if (mouse_check_button_pressed(mb_left)) {OnClick();}
	}
	else
	{
		image_xscale = 1.5;
		image_yscale = 1.5;
	}
	
	ChildUpdate();
}

function ChildUpdate()
{
	if (objGm.state == STATE.PLAYER) {card = objGm.playerHandChosen;}
	else if (objGm.state == STATE.COMPUTER && global.multiplayer) {card = objGm.computerHandChosen;}
	else {card = noone;}
		
	if (card != noone)
	{
		visible = true;
		x = card.x+45;
		y = card.y-45;
	}
	else
	{
		visible = false;
	}
}

function OnClick()
{
	if (card != noone)
	{
		//show_debug_message("clicked " + string(object_index));
		card.RotateCard(true);
	}
}

card = noone;

function Update()
{
	if (mouse_check_button_pressed(mb_left) &&
		position_meeting(mouse_x, mouse_y, id))
	{
		OnClick();
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
		x = card.targetX-50;
		y = card.targetY-50;
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
		show_debug_message("clicked " + string(object_index));
		card.RotateCard(false);
	}
}
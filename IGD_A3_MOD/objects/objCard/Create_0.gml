//faceIndex = 0;

faces = array_create(4);
playedBy = 0; // 1: player; 2: computer
faceUp = false;
inPlayerHand = false;
targetDepth = 0;
targetX = 0;
targetY = 0;
targetRot = 0;
lerpSpd = .15;

hover = false;
hoverYOffset = objGm.handYOffset * .1;

function Update()
{
	if (objGm.playerHandChosen == id)
	{
		if (keyboard_check_pressed(vk_left))
		{RotateCard(false);}
		if (keyboard_check_pressed(vk_right))
		{RotateCard(true);}
	}
	
	// lerping
	if (abs(x-targetX)>1)
	{x = lerp(x,targetX,lerpSpd);}
	else
	{x = targetX;}
	
	if (abs(y-targetY)>1)
	{y = lerp(y,targetY,lerpSpd);}
	else
	{y = targetY;}
	
	
	if (abs(image_angle-targetRot)>1)
	{image_angle = lerp(image_angle, targetRot, .5);}
	else
	{image_angle = targetRot;}
	
	
	/*
	if (image_angle>targetRot)
	{image_angle--;}
	else if (image_angle<targetRot)
	{image_angle++;}
	if (abs(image_angle-targetRot) < 2)
	{image_angle = targetRot;}
	*/
	
	
	// player action w/ card
	if (objGm.state == STATE.PLAYER)
	{
		if (objGm.playerState == PLAY_STATE.SELECT_CARD || objGm.playerState == PLAY_STATE.SELECT_SLOT)
		{
			if (inPlayerHand && objGm.playerHandChosen != id)
			{
				if (position_meeting(mouse_x, mouse_y, id) && mouse_check_button_pressed(mb_left))
				{
					//audio_play_sound(sndPaper, 0, false);
					
					if (objGm.playerHandChosen != noone)
					{
						var c = objGm.playerHandChosen;
						c.targetY += objGm.handYOffset / 2;
						ds_list_add(objGm.playerHand, c);
						c.inPlayerHand = true;
					}
					
					targetY -= objGm.handYOffset / 2;
					ds_list_delete(objGm.playerHand, ds_list_find_index(objGm.playerHand, id))
					inPlayerHand = false;
					if (hover)
					{
						hover = false;
						targetY = targetY + hoverYOffset;
					}
					
					objGm.playerHandChosen = id;
					objGm.playerState = PLAY_STATE.SELECT_SLOT;
					//objGm.state = STATE.RESULT;
				}
				else if (!hover && position_meeting(mouse_x, mouse_y, id))
				{
					hover = true;
					targetY = targetY - hoverYOffset;
				}
				else if (hover && !position_meeting(mouse_x, mouse_y, id))
				{
					hover = false;
					targetY = targetY + hoverYOffset;
				}
			}
		}
	}
}

function RotateCard(clockwise)
{
	var tempArray = array_create(4);
	if (clockwise)
	{
		show_debug_message("cw");
		targetRot -= 90;
		
		for (var i=0; i<array_length(faces); i++)
		{
			if (i==array_length(faces)-1)
			{tempArray[0] = faces[array_length(faces)-1];}
			else
			{tempArray[i+1] = faces[i];}
		}
	}
	else if (!clockwise)
	{
		show_debug_message("ccw");
		targetRot += 90;
		
		for (var i=0; i<array_length(faces); i++)
		{
			if (i==0)
			{tempArray[array_length(faces)-1] = faces[0];}
			else
			{tempArray[i-1] = faces[i];}
		}
	}
	faces = tempArray;
}
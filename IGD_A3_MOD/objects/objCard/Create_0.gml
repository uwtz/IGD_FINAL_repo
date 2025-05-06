//faceIndex = 0;

faces = array_create(4);
playedBy = 0; // 1: player; 2: computer
faceUp = false;
inHand = HAND_OF.NOONE;
targetDepth = 0;
targetX = 0;
targetY = 0;
targetRot = 0;
lerpSpd = .15;

hover = false;
hoverYOffset = objGm.handYOffset * .1;

enum HAND_OF
{
	NOONE,
	PLAYER,
	COMPUTER
}

function Update()
{
	if (objGm.playerHandChosen == id || (objGm.computerHandChosen == id && global.multiplayer))
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
			if (inHand == HAND_OF.PLAYER && objGm.playerHandChosen != id)
			{
				if (position_meeting(mouse_x, mouse_y, id) && mouse_check_button_pressed(mb_left))
				{
					//audio_play_sound(sndPaper, 0, false);
					
					if (objGm.playerHandChosen != noone)
					{
						var c = objGm.playerHandChosen;
						c.targetY += objGm.handYOffset / 2;
						ds_list_add(objGm.playerHand, c);
						c.inHand = HAND_OF.PLAYER;
					}
					
					targetY -= objGm.handYOffset / 2;
					ds_list_delete(objGm.playerHand, ds_list_find_index(objGm.playerHand, id))
					inHand = HAND_OF.NOONE;
					if (hover)
					{
						hover = false;
						targetY = targetY + hoverYOffset;
					}
					
					//show_debug_message(GetFaces());
					//show_debug_message(faces);
					
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
	else if (objGm.state == STATE.COMPUTER && global.multiplayer == true)
	{
		if (objGm.computerState == PLAY_STATE.SELECT_CARD || objGm.computerState == PLAY_STATE.SELECT_SLOT)
		{
			if (inHand == HAND_OF.COMPUTER && objGm.computerHandChosen != id)
			{
				if (position_meeting(mouse_x, mouse_y, id) && mouse_check_button_pressed(mb_left))
				{
					//audio_play_sound(sndPaper, 0, false);
					
					if (objGm.computerHandChosen != noone)
					{
						var c = objGm.computerHandChosen;
						c.targetY += objGm.handYOffset / 2;
						ds_list_add(objGm.computerHand, c);
						c.inHand = HAND_OF.COMPUTER;
					}
					
					targetY -= objGm.handYOffset / 2;
					ds_list_delete(objGm.computerHand, ds_list_find_index(objGm.computerHand, id))
					inHand = HAND_OF.NOONE;
					if (hover)
					{
						hover = false;
						targetY = targetY + hoverYOffset;
					}
					
					objGm.computerHandChosen = id;
					objGm.computerState = PLAY_STATE.SELECT_SLOT;
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
	//var tempArray = array_create(4);
	if (clockwise)
	{
		//show_debug_message("cw");
		targetRot -= 90;
		
		/*for (var i=0; i<array_length(faces); i++)
		{
			if (i==array_length(faces)-1)
			{tempArray[0] = faces[array_length(faces)-1];}
			else
			{tempArray[i+1] = faces[i];}
		}*/
	}
	else if (!clockwise)
	{
		//show_debug_message("ccw");
		targetRot += 90;
		
		/*for (var i=0; i<array_length(faces); i++)
		{
			if (i==0)
			{tempArray[array_length(faces)-1] = faces[0];}
			else
			{tempArray[i-1] = faces[i];}
		}*/
	}
	show_debug_message(targetRot);
	//faces = tempArray;
}

// get face array mod by rotation
function GetFaces()
{
	var rot = (targetRot + 360) mod 360;
	var offset;
	switch (rot)
	{
		case 0: offset = 0; break;
		case 90: offset = 1; break;
		case 180: offset = 2; break;
		case 270: offset = 3; break;
	}
	
	var len = array_length(faces);
	var tempArray = array_create(len);
	for (var i=0; i<len; i++)
	{
		tempArray[ (i - offset + len) mod len ] = faces[i];
	}
	
	return tempArray;
}

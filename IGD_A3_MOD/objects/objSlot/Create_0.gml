cardInSlot = noone;
coord = array_create(2);
maxScale = 1.2;
targetScale = maxScale;


function Update()
{
	if (objGm.state == STATE.PLAYER)
	{
		if (objGm.playerState == PLAY_STATE.SELECT_SLOT && cardInSlot == noone)
		{
			
			
			if (position_meeting(mouse_x, mouse_y, id))
			{
				image_xscale = 1.1;
				image_yscale = 1.1;
				if (mouse_check_button_pressed(mb_left))
				{
					audio_play_sound(sndPaper, 0, false)
					objGm.playerHandChosen.targetX = x;
					objGm.playerHandChosen.targetY = y;
					cardInSlot = objGm.playerHandChosen;
					image_xscale = 1;
					image_yscale = 1;
					
					objGm.playerHandChosen = noone;
					
					if (ds_list_size(objGm.computerHand) > 0)
					{
						objGm.state = STATE.COMPUTER;
						objGm.computerState = PLAY_STATE.SELECT_CARD;
					}
					else
					{
						objGm.state = STATE.RESULT;
					}
				}
			}
			else
			{
				image_xscale = 1;
				image_yscale = 1;
			}
		}
	}
}

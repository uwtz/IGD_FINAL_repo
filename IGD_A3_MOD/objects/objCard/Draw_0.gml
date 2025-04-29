depth = targetDepth;

//if (faceIndex == FACE.ROCK) {sprite_index = sprRock;}
//if (faceIndex == FACE.PAPER) {sprite_index = sprPaper;}
//if (faceIndex == FACE.SCISSOR) {sprite_index = sprScissor;}
if (!faceUp) {sprite_index = sprCardBack;}
else
{
	switch (playedBy)
	{
		case 0:
			sprite_index = sprCardFront;
			break;
		case 1:
			sprite_index = sprCardFront1;
			break;
		case 2:
			sprite_index = sprCardFront2;
			break;
	}
}

//draw_sprite(sprite_index, image_index, x, y);
draw_self();



if (faceUp)
{
	for (var i=0; i<array_length(faces); i++)
	{
		var spr;
		//show_debug_message(faces);
		switch (faces[i])
		{
			case FACE.ROCK:
				spr = sprRockIcon;
				break;
			case FACE.PAPER:
				spr = sprPaperIcon;
				break;
			case FACE.SCISSOR:
				spr = sprScissorIcon;
				break;
		}
	
		switch (i)
		{
			case 0:
				draw_sprite_ext(spr, 0, x+0, y-20, 1.2, 1.2, 0, c_white, 1);
				break;
			case 1:
				draw_sprite_ext(spr, 0, x+20, y+0, 1.2, 1.2, 270, c_white, 1);
				break;
			case 2:
				draw_sprite_ext(spr, 0, x+0, y+20, 1.2, 1.2, 180, c_white, 1);
				break;
			case 3:
				draw_sprite_ext(spr, 0, x-20, y+0, 1.2, 1.2, 90, c_white, 1);
				break;
		}
	}
}

depth = targetDepth;

//if (faceIndex == FACE.ROCK) {sprite_index = sprRock;}
//if (faceIndex == FACE.PAPER) {sprite_index = sprPaper;}
//if (faceIndex == FACE.SCISSOR) {sprite_index = sprScissor;}


/*if (!faceUp) {sprite_index = sprCardBack;}
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
}*/

//draw_sprite(sprite_index, image_index, x, y);

if (!faceUp) {sprite_index = sprCardBack;}
else{sprite_index = sprCardFront;}
draw_self();



if (faceUp)
{
	
	
	var icon_index = playedBy;
	var card_rotation = image_angle;
    var icon_distance = 20; // how far each face is from center
    var icon_scale = 1.2;


    for (var i = 0; i < array_length(faces); i++)
    {
        var spr;
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

        // Calculate base angle for this face
        var base_angle;
        switch (i)
        {
            case 0: base_angle = 90; break; // top
            case 1: base_angle = 0; break;   // right
            case 2: base_angle = 270; break;  // bottom
            case 3: base_angle = 180; break; // left
        }

        // Final angle considering the card's rotation
        var final_angle = card_rotation + base_angle;

        // Calculate rotated position
        var dx = lengthdir_x(icon_distance, final_angle);
        var dy = lengthdir_y(icon_distance, final_angle);

        // Draw the sprite
        draw_sprite_ext(
            spr,
            icon_index,
            x + dx,
            y + dy,
            icon_scale,
            icon_scale,
            final_angle-90,
            c_white,
            1
        );
    }
}

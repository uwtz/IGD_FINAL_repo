//draw_set_color(clr);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

var scale = .8;
if (clr == c_blue) {draw_sprite_ext(sprP1, 0, x, y, scale, scale, 0, c_white, 1);}
else if (clr == c_red) {draw_sprite_ext(sprP2, 0, x, y, scale, scale, 0, c_white, 1);}
else {draw_sprite_ext(sprP3, 0, x, y, scale, scale, 0, c_white, 1);}


//draw_set_font(fnt2);
//draw_text(x,y,txt);
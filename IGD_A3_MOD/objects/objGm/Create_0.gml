// ANY REFERENCE TO COMPUTER REFERES TO PLAYER2 IN CASE OF MULTIPLAYER
//show_debug_message(global.multiplayer);

handXOffset = sprite_get_width(sprCardBack) + 10;
handYOffset = sprite_get_height(sprCardBack) + 10;
deckYOffset = 4;

numCards = 24;

dealing = true;


deck = ds_list_create();
discard = ds_list_create();

playerHand = ds_list_create();
computerHand = ds_list_create();

playerHandChosen = noone;
computerHandChosen = noone;

result = noone;

stopwatch = 0;
cardCooldown = .25 * game_get_speed(gamespeed_fps);
computerCooldown = .75 * game_get_speed(gamespeed_fps);
resultCooldown = 1 * game_get_speed(gamespeed_fps);
shuffleCooldown = .1 * game_get_speed(gamespeed_fps);
cleanCooldown = .1 * game_get_speed(gamespeed_fps);

n = numCards;
k = 0;

enum STATE
{
	DEALING,
	COMPUTER,
	PLAYER,
	RESULT,
	RESULTCROWN,
	CLEANHAND,
	SHUFFLE
}

state = STATE.DEALING;

yuh = 0;

pointPlayer = 0;
pointComputer = 0;

enum RESULT
{
	WIN,
	LOSE,
	TIE
}

enum FACE
{
	ROCK,
	PAPER,
	SCISSOR
}


enum PLAY_STATE
{
	SELECT_CARD,
	SELECT_SLOT
}

playerState = PLAY_STATE.SELECT_CARD;
computerState = PLAY_STATE.SELECT_CARD;

slots = array_create(8);

function GetEmptySlots()
{
	var empty = [];
	for (var i=0; i<array_length(slots); i++)
	{
		if (slots[i].cardInSlot == noone)
		{
			array_push(empty, slots[i]);
		}
	}
	return empty;
}

edger = 0;
// [ [slot A, face A], [slot B, face B] ]
edges =
[
	[ [0,1], [1,3] ],
	[ [1,1], [2,3] ],
	[ [0,2], [3,0] ],
	[ [1,2], [4,0] ],
	[ [2,2], [5,0] ],
	[ [3,1], [4,3] ],
	[ [4,1], [5,3] ],
	[ [3,2], [6,0] ],
	[ [4,2], [7,0] ],
	[ [5,2], [8,0] ],
	[ [6,1], [7,3] ],
	[ [7,1], [8,3] ]
];

roundScore = array_create(2);

crownInst = ds_list_create();

function GetFace(i)
{
	if (i==0)
	{return FACE.ROCK;}
	if (i==1)
	{return FACE.PAPER;}
	if (i==2)
	{return FACE.SCISSOR;}
}

// initiate cards
randomize();
for (var i=0; i<numCards; i++)
{
	var newCard = instance_create_layer(0,0,"Instances", objCard);
	
	for (var j=0; j<array_length(newCard.faces); j++)
	{
		newCard.faces[j] = GetFace(floor(random(3)));
	}
	//show_debug_message(newCard.faces);
	newCard.faceUp = false;
	newCard.inHand = HAND_OF.NOONE;
	newCard.targetDepth = 0;
	
	ds_list_add(deck, newCard);
}


randomize();
ds_list_shuffle(deck);

for (var i=0;i<ds_list_size(deck); i++)
{
	var card = ds_list_find_value(deck, i)
	card.targetX = room_width/2;
	card.targetY  = room_height * .82 - deckYOffset*i;
	card.x = room_width/2;
	card.y  = room_height * .5 - deckYOffset*i;
	card.targetDepth = -i;
	//show_debug_message(string(ds_list_find_value(deck, i).y) + ", " + string(ds_list_find_value(deck, i).depth));
}

started = false;
function Start()
{
	// set slots
	for (var i=0; i<instance_number(objSlot); i++)
	{
		var _slot = instance_find(objSlot, i);
		//show_debug_message(_slot);
		var _slotId = _slot.slotId;
		slots[_slotId] = _slot;
	}
	var _xc = 0;
	var _yc = 0;
	for (var i=0; i<array_length(slots); i++)
	{
		//show_debug_message([_xc, _yc])
		slots[i].coord = [_xc, _yc];
		_xc++;
		if (_xc >= 3)
		{
			_xc = 0;
			_yc++;
			if (_yc >= 3) {_yc = 0;}
		}
	}
	
	with (objHandTransform)
	{
		objGm.SetHandTransform(cardTransformId, id);
	}
}

/*
shuffle
deal one card to center/random slot
deal 4 cards to each player

	player 1 place a card
	player 2 place a card

score when board is full

*/

function Update()
{
	if (keyboard_check_pressed(vk_escape))
	{
		room_goto(Room2);
	}
	
	switch (state)
	{
		case STATE.DEALING:
			stopwatch++;
			if (stopwatch >= cardCooldown)
			{
				stopwatch=0;
				
				if (ds_list_size(playerHand) < 4)
				{
					audio_play_sound(sndPaper, 0, false);
					var dealtCard = ds_list_find_value(deck, ds_list_size(deck)-1);
					ds_list_delete(deck, ds_list_size(deck)-1);
					ds_list_add(playerHand, dealtCard);
			
					dealtCard.inHand = HAND_OF.PLAYER;
					dealtCard.faceUp = true;
					dealtCard.playedBy = 1;
					
					var transform = GetHandTransform(ds_list_size(playerHand)-1);
					dealtCard.targetX = transform.x;
					dealtCard.targetY = transform.y;
					dealtCard.targetRot = transform.image_angle;
					
				}
				else if (ds_list_size(computerHand) < 4)
				{
					audio_play_sound(sndPaper, 0, false);
					var dealtCard = ds_list_find_value(deck, ds_list_size(deck)-1);
					ds_list_delete(deck, ds_list_size(deck)-1);
					ds_list_add(computerHand, dealtCard);
			
					dealtCard.inHand = HAND_OF.COMPUTER;
					dealtCard.faceUp = true;
					dealtCard.playedBy = 2;
					
					var transform = GetHandTransform(ds_list_size(computerHand)-1);
					dealtCard.targetX = room_width - transform.x;
					dealtCard.targetY = transform.y;
					dealtCard.targetRot = transform.image_angle;
				}
				else
				{
					audio_play_sound(sndPaper, 0, false);
					var dealtCard = ds_list_find_value(deck, ds_list_size(deck)-1);
					ds_list_delete(deck, ds_list_size(deck)-1);
					slots[4].cardInSlot = dealtCard;
					dealtCard.targetX = slots[4].x;
					dealtCard.targetY = slots[4].y;
					dealtCard.faceUp = true;
					state = STATE.PLAYER;
					stopwatch = 0;
					playerState = PLAY_STATE.SELECT_CARD;
				}
			}
			break;
		
		
		case STATE.PLAYER:
			break;
			
		
		
		case STATE.COMPUTER:
			if (!global.multiplayer)
			{
				stopwatch++;
				if (stopwatch >= computerCooldown)
				{
					stopwatch=0;
					if (computerState == PLAY_STATE.SELECT_CARD)
					{
						//audio_play_sound(sndPaper, 0, false);
						randomize();
						var _r =  int64(random(ds_list_size(computerHand)));
						computerHandChosen = ds_list_find_value(computerHand,_r);
						//show_debug_message(computerHandChosen);
						ds_list_delete(computerHand,_r);
						computerHandChosen.targetX = computerHandChosen.targetX;
						computerHandChosen.targetY = computerHandChosen.targetY - handYOffset/2;
						computerHandChosen.faceUp = true;
			
						computerState = PLAY_STATE.SELECT_SLOT;
					}
					else if (computerState == PLAY_STATE.SELECT_SLOT)
					{
						audio_play_sound(sndPaper, 0, false);
						randomize();
						var _empty = GetEmptySlots();
						var _r = floor(random(array_length(_empty)));
						_empty[_r].cardInSlot = computerHandChosen;
						computerHandChosen.targetX = _empty[_r].x;
						computerHandChosen.targetY = _empty[_r].y;
					
						computerState = PLAY_STATE.SELECT_CARD;
					
						if (ds_list_size(objGm.computerHand) > 0)
						{
							state = STATE.PLAYER;
							playerState = PLAY_STATE.SELECT_CARD;
						}
						else
						{
							stopwatch = 0;
							state = STATE.RESULT;
						}
					}
				}
			}
			break;
		
		case STATE.RESULT:
			stopwatch++;
			
			if (yuh == 0)
			{
				if (stopwatch >= 50)
				{
					stopwatch = 0;
					yuh = 1;
				}
			}
			else if (yuh == 1)
			{
				if (stopwatch >= 20 && edger < array_length(edges))
				{
					stopwatch = 0;
				
					var edge = edges[edger];
					var slot1 = slots[edge[0][0]];
					var slot2 = slots[edge[1][0]];
					var card1 = slot1.cardInSlot;
					var card2 = slot2.cardInSlot;
					var face1 = card1.GetFaces()[edge[0][1]];
					var face2 = card2.GetFaces()[edge[1][1]];
				
					var rps_result =
					[
						[0, 2, 1], // ROCK:    ROCK, PAPER, SCISSOR
						[1, 0, 2], // PAPER:   ROCK, PAPER, SCISSOR
						[2, 1, 0]  // SCISSOR: ROCK, PAPER, SCISSOR
					];

					var winningCard = rps_result[face1][face2]; //0 tie; 1 face1; 2 face2;
					var winningPlayer = 0;
				
					if (winningCard == 1)
					{
						if (card1.playedBy==1)
						{
							roundScore[0]++;
							winningPlayer = 1;
						}
						else if (card1.playedBy==2)
						{
							roundScore[1]++;
							winningPlayer = 2;
						}
					}
					else if (winningCard == 2)
					{
						if (card2.playedBy==1)
						{
							roundScore[0]++;
							winningPlayer = 1;
						}
						else if (card2.playedBy==2)
						{
							roundScore[1]++;
							winningPlayer = 2;
						}
					}
				
					var s = instance_create_depth((slot1.x+slot2.x)/2, (slot1.y+slot2.y)/2, 0, objScorePopUp);
					ds_list_add(crownInst, s);
				
				
					if (winningPlayer == 1)
					{
						s.clr = c_blue;
						s.txt = "+1";
					}
					else if (winningPlayer == 2)
					{
						s.clr = c_red;
						s.txt = "+1";
					}
					else if (winningPlayer == 0)
					{
						s.clr = c_white;
						s.txt = "+0";
					}
					//show_debug_message("Card1: " + string(card1.faces) + ", Card2: " + string(card2.faces));
					//show_debug_message("Result: " + string(winningCard));
				
					edger++;
				}
			
				if (stopwatch >= 30 && edger >= array_length(edges))
					{
						edger = 0;
						yuh = 0;
						stopwatch = 0;
					
						state = STATE.RESULTCROWN;
					}
			}
			
			break;
			
		case STATE.RESULTCROWN:
		
			stopwatch++;
			
			if (stopwatch >= 20)
			{
				if (stopwatch >= 160)
				{
					stopwatch = 0;
					
					with (objScorePopUp)
					{instance_destroy(id);}
					
					state = STATE.CLEANHAND;
				}
				
				if (ds_list_size(crownInst) <= 0 && stopwatch >= 100)
				{
					//show_debug_message(roundScore);
					if (roundScore[0]>roundScore[1])
					{
						pointPlayer++;
						audio_play_sound(sndWin, 0, false);
					}
					else if (roundScore[0]<roundScore[1])
					{
						pointComputer++;
						if (!global.multiplayer){audio_play_sound(sndLose, 0, false);}
						else {audio_play_sound(sndWin, 0, false);}
					}
					roundScore = array_create(2);
					
					objCrownCounterPlayer.count = 0;
					objCrownCounterComputer.count = 0;
				}
				
				else if (ds_list_size(crownInst) > 0)
				{
					stopwatch = 0;
					var crown = crownInst[| 0];
					ds_list_delete(crownInst, 0);
					
					if (crown.clr == c_white)
					{
						stopwatch = 20;
					}
					else if (crown.clr == c_blue)
					{
						objCrownCounterPlayer.count++;
						crown.SetTargetLoc(objCrownCounterPlayer.x, objCrownCounterPlayer.y);
						crown.targetCounter = objCrownCounterPlayer;
						crown.destroyOnTarget = true;
						//show_debug_message(string(crown)+" to (" + string(crown.targetX) + ", " + string(crown.targetY) + "). Counter At: (" + string(objCrownCounterPlayer.x) + ", " + string(objCrownCounterPlayer.y) + ")");
					}
					else if (crown.clr == c_red)
					{
						objCrownCounterComputer.count++;
						crown.SetTargetLoc(objCrownCounterComputer.x, objCrownCounterComputer.y);
						crown.targetCounter = objCrownCounterComputer;
						crown.destroyOnTarget = true;
					}
					
				}
				
			}
			
			break;
		
		case STATE.CLEANHAND:
			/*for (var i=0; i<array_length(slots); i++)
			{
				show_debug_message(string(slots[i].slotId) + ", " + string(slots[i].cardInSlot));
			}*/
			
			stopwatch++;
			if (stopwatch >= cleanCooldown)
			{
				stopwatch = 0;
				if (k<array_length(slots))
				{
					var card = slots[k].cardInSlot;
					//show_debug_message(card);
					//show_debug_message(slots[k].slotId);
				
					slots[k].cardInSlot = noone;
					ds_list_add(deck, card);
				
					card.targetX = room_width/2;
					card.targetY  = room_height * .82 - deckYOffset*(ds_list_size(deck)-1);
					card.targetDepth = -(ds_list_size(deck)-1);
					card.faceUp = false;
					card.playedBy = 0;
					card.targetRot = 0;
					card.image_angle = card.targetRot;
					
					k++;
				}
				else
				{
					k=0;
					
					randomize();
					ds_list_shuffle(deck);
					playerHandChosen = noone;
					computerHandChosen = noone;
					state = STATE.SHUFFLE;
				}
			}
		
			break;
			
		case STATE.SHUFFLE:
			stopwatch++;
			
			if (stopwatch >= shuffleCooldown)
			{
				stopwatch = 0;
				audio_play_sound(sndPaper, 0, false);
				/*
				if (ds_list_size(discard) > 0)
				{
				
						var card = ds_list_find_value(discard, ds_list_size(discard)-1);
						ds_list_delete(discard, ds_list_size(discard)-1);
						ds_list_add(deck, card);
						card.targetX = handXOffset;
						card.targetY  = room_height/2 - deckYOffset * (ds_list_size(deck)-1);
						card.targetDepth = -(ds_list_size(deck)-1);
						card.faceUp = false;
					
						if (ds_list_size(discard)==0)
						{
							randomize();
							ds_list_shuffle(deck);
						}
				}*/
				if (n>0)
				{
					var card = ds_list_find_value(deck, n-1);
					card.targetX = room_width/2;
					card.targetY  = room_height * .82 - deckYOffset*n;
					card.targetDepth = -(n-1);
					n--;
				}
				else
				{
					n = numCards;
					playerHand = ds_list_create();
					computerHand = ds_list_create();
					state = STATE.DEALING;
				}
			}
			
			break;
	}
}




handTransforms = array_create(4, noone);

function GetHandTransform(i)
{
	return handTransforms[i];
}

function SetHandTransform(i, _id)
{
	handTransforms[i] = _id;
}
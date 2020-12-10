// Layout by cools / Arcade Otaku
// For use in a 640x240 resolution
// We use this strange resolution to enhance the front rendering quality in 15KHz
//
// Layout User Options
class UserConfig {
 }
 local my_config=fe.get_config();
 
 // Colour cycle code from LukeNukem
 cycleVTable <-{
  "cnListHeight":0,"swListHeight":0,"wkListHeight":0,
  "cnListRed":0,"swListRed":0,"wkListRed":0,
  "cnListGreen":0,"swListGreen":0,"wkListGreen":0,
  "cnListBlue":0,"swListBlue":0,"wkListBlue":0,
 }
 function cycleValue(ttime,counter,switcher,workValue,minV,maxV,BY,speed){
  if (cycleVTable[counter] == 0)
   cycleVTable[counter]=ttime;
 ////////////// 1000=1 second //////////////
  if (ttime-cycleVTable[counter]>speed){
   if (cycleVTable[switcher]==0){
    cycleVTable[workValue]+=BY;
    if (cycleVTable[workValue]>=maxV)
     cycleVTable[switcher]=1;
   }
   else if (cycleVTable[switcher]==1){
    cycleVTable[workValue]-=BY;
    if (cycleVTable[workValue]<=minV)
     cycleVTable[switcher]=0;
   }    
  cycleVTable[counter]=0;
  }
  return cycleVTable[workValue];	
 }
 
 // Gives us a nice high random number for the RGB levels
 function brightrand() {
   return 255-(rand()/512);
 }
 
 // Layout Constants
 fe.layout.orient=RotateScreen.Right;
//  fe.layout.width=1280;
//  fe.layout.height=960;
 fe.layout.preserve_aspect_ratio=true;

 local flw=fe.layout.width;
 local flh=fe.layout.height;
 local rot=(fe.layout.base_rotation+fe.layout.toggle_rotation)%4;
 switch (rot) {
  case RotateScreen.Right:
  case RotateScreen.Left:
   fe.layout.width=flh;
   fe.layout.height=flw;
   flw=fe.layout.width;
   flh=fe.layout.height;
   break;
 }


 local itn = 5;
 local mlh = flh/itn;
 local mlw = mlh * 2.74285;
 local mlx = (flw-mlw)/2
 local mly = 0;
 for (local i=-(itn/2);i<=(itn/2);i+=1){
    local gamelist=fe.add_artwork("marquee",mlx,mly,mlw,mlh);
    gamelist.preserve_aspect_ratio=false;
    if (i==0) {
      gamelist.set_rgb(255,255,255);
      gamelist.alpha=255;    
    } else {
      gamelist.set_rgb(100,100,100);
      gamelist.alpha=100;    
    }
    gamelist.index_offset=i;

    mly += mlh;

 }

 fe.ambient_sound = fe.add_sound("last_star_fighter_battle.mp3")
 
 function transition_effects( ttype, var, ttime )
{
  switch ( ttype )
  {
    case Transition.StartLayout:
      fe.ambient_sound.playing = true;
      break;
    case Transition.ToGame:
      fe.ambient_sound.playing = false;
      local selectionSound = fe.add_sound("coin.wav")
      selectionSound.playing=true;
      break;
    case Transition.FromGame:
      fe.ambient_sound.playing = true;
      break;
    case Transition.ToNewSelection:
      local selectionSound = fe.add_sound("swosh.wav")
      selectionSound.playing=true;
      if (!fe.ambient_sound.playing) {
        fe.ambient_sound.playing = true;
      }
      break;
  }
  return false;
}
 
fe.add_transition_callback( "transition_effects" );

local phrases = ["Up to your old Excalibur tricks again, eh, Centauri?",
"Greetings, Starfighter. You have been recruited by the Star League to defend the frontier against Xur and the Ko-Dan armada.",
"Hold it! There's no fleet? No Starfighters, no plan? One ship, you, me, and that's it?",
"Teriffic. I'm about to get killed a million miles from nowhere with a gung-ho iguana who tells me to relax.",
"I've always wanted to fight a desperate battle against incredible odds.",
"Remember, Death Blossom delivers only one massive volley at close range, theoretically.",
"After all, D.B. has never been tested. It might overload the systems, blow up the ship!",
"What are you worried about, Grig? Theoretically, we should already be dead!"];
local phraseIndex = 0;
local phraseLength = 7;

 local freeplayleft=fe.add_text(phrases[phraseIndex],flw,0,flw*3,flh*0.03);
 freeplayleft.align=Align.Left;
//  freeplayleft.alpha=85;
//  local freeplayright=fe.add_text("Free Play",0,0,flw,flh*0.03);
//  freeplayright.align=Align.Right;
//  freeplayright.alpha=85;
//  local inssh=fe.add_text("Instructions",1,(flh*0.94),flw,flh*0.02);
 
 function textTickles(ttime){		
  freeplayleft.x = freeplayleft.x-2;
  if (freeplayleft.x <= -(freeplayleft.width+flw))
  {
    freeplayleft.msg = phrases[++phraseIndex];
    freeplayleft.x = flw;
    if (phraseIndex == phraseLength){
      phraseIndex=-1;
    }
  }
 }
 
 function fades(ttype,var,ttime){
  switch (ttype){
   case Transition.FromGame:
    return false;
    break;
   case Transition.ToGame:
    if (ttime<10){
     return true;
    }
    break;
   case Transition.EndLayout:
    if (ttime<10){
     return true;
    }
    return false;
  }
 }
 
fe.add_ticks_callback( "textTickles" );
 fe.add_transition_callback( "fades" );
 
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

 
 function transition_effects( ttype, var, ttime )
{
  switch ( ttype )
  {
    case Transition.ToGame:
      local selectionSound = fe.add_sound("coin.wav")
      selectionSound.playing=true;
      break;
    case Transition.ToNewSelection:
      local selectionSound = fe.add_sound("swosh.wav")
      selectionSound.playing=true;
      break;
  }
  return false;
}
 
fe.add_transition_callback( "transition_effects" );

 local freeplayleft=fe.add_text("Free Play",0,0,flw,flh*0.03);
 freeplayleft.align=Align.Left;
//  freeplayleft.alpha=85;
 local freeplayright=fe.add_text("Free Play",0,0,flw,flh*0.03);
 freeplayright.align=Align.Right;
//  freeplayright.alpha=85;
//  local inssh=fe.add_text("Instructions",1,(flh*0.94),flw,flh*0.02);
 local help_text=fe.add_text("Play Game [BUTTON1]  -  Quit Game [START1+2]",0,flh*0.97,flw,flh*0.02);
 
 function textTickles(ttime){		
  local grey=brightrand();
  freeplayleft.set_rgb(grey,grey,grey);
  freeplayright.set_rgb(grey,grey,grey);
  help_text.set_rgb(grey,grey,grey);
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
 
//  fe.add_ticks_callback( "textTickles" );
 fe.add_transition_callback( "fades" );
 
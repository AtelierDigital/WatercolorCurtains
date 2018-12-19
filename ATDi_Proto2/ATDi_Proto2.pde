//import processing.sound.*;
import de.voidplus.leapmotion.*;
import ddf.minim.*;
 
Minim minim;
AudioPlayer windSound;
AudioPlayer jungleMorning;
AudioPlayer fireSound;

float a = 0;
PImage myImage, myImage2, myImage3, myImage4;
PGraphics pg;
PGraphics pg2;
//
float x,y;

int nrects = 150;
float nRectsPercentage =1.0f;
float rectWidthFactor = 0.5;
float rectHeightFactor = 0.5;

float userFactor = 1;

float userRange = 50;    
float userRange2 = 50;

float treePosX = 0;
float treePosX2;

PImage mask;

//SoundFile windSound;
//SoundFile jungleMorning;

LeapMotion leapMotion;

float volume;
//  Tudo isto porque parece que as transicoes da Minim nao conseguem se sobrepor...
boolean transitionedHandsON;
int transitionHandsON_msecs = 500;
int transitionHandsON_msecs_TIMER;

int currTime, prevTime;  // milliseconds

void setup() 
{
  minim = new Minim(this);
  windSound = minim.loadFile("Sounds/WindBlows.mp3", 512);
  //windSound.loop();
  
  jungleMorning = minim.loadFile("Sounds/JungleMorning.mp3", 512);
  //jungleMorning.loop();
  
  fireSound = minim.loadFile("Sounds/17548__dynamicell__fire-forest-inferno_LOOP.mp3",512);
  fireSound.setGain(-30.0f);
  fireSound.loop();
  //windSound = new SoundFile(this, "/Sounds/WindBows.mp3");
  //jungleMorning = new SoundFile(this, "/Sounds/JungleMorning.mp3");
  
  size(1920, 1080);
  pg = createGraphics(width, height);
  pg2 = createGraphics(width, height);
  
  myImage = loadImage("IMG_3237.jpg").get(0,0, 1500,1080);
  myImage.resize(width,height);
  
  myImage2 = loadImage("forest.jpg").get(0,0, 1500,1080);
  myImage2.resize(width,height);
  
  myImage3 = loadImage("fire_texture1421.jpg");
  myImage3.resize(width,height);
  
  treePosX2 = width;
  
  //windSound.play(0.5, 0.3);  
  //jungleMorning.play(0.8,1.0);
  
  frameRate(30);
  
  leapMotion = new LeapMotion(this);
  
  transitionedHandsON = false;
  transitionHandsON_msecs_TIMER = transitionHandsON_msecs;
  
  noCursor();
}

void draw() 
{ 
  currTime = millis();
  
  pg.beginDraw();
  
  int count = 0;
  color myColor = 0;
    
  if(leapMotion.getHands ().size() > 0){
    for (Hand hand : leapMotion.getHands ()) {
      float ratio = map(hand.getPalmPosition().y, -300 , 800, 0.2, 1.2);  
      userRange = 20 + 170 * (ratio * ratio);
      rectHeightFactor = (ratio /ratio / ratio / ratio);
      rectWidthFactor = map(ratio, 0.2 , 1.2, 0.5, 0.7);  
      
      PickColor(hand, myColor);
      //println("HAND"+count+" :"+hand.getPalmPosition().x);
      
      if(!transitionedHandsON)
      {
        if(transitionHandsON_msecs_TIMER == transitionHandsON_msecs) // inicia rampa
        {
          volume = 10+ (-30 * (1.2 - ratio));
          fireSound.shiftGain(fireSound.getGain(), volume, transitionHandsON_msecs);
          transitionHandsON_msecs_TIMER -= (currTime - prevTime);
          println("-- ramp --");
        }
        else // finalizamos a rampa
        {
          transitionHandsON_msecs_TIMER -= (currTime - prevTime);
          if(transitionHandsON_msecs_TIMER <= 0) {
            transitionedHandsON = true;
            transitionHandsON_msecs_TIMER = transitionHandsON_msecs;
          }
        }
      }
      else // nao estamos mais na rampa
      {
        volume = 10+ (-30 * (1.2 - ratio));
        //println(volume);
        fireSound.setGain(volume);
      }
      count++;
    }
    
  } 
  else
  {
    fireSound.shiftGain(fireSound.getGain(), -30.0f, 1000);
    transitionedHandsON = false; // pronto para a proxima rampa 
      
    PickColor(null,myColor);
  }      
  
  pg.endDraw();
  
  image(pg,0,0);
   
   
  prevTime = currTime;
}

public void PickColor(Hand hand,color out)
{ 
  for(int i =0; i< nrects; i++)
  {
    
    x = random(0, myImage.width);
    y = random(0, myImage.height);
    pg.noStroke();
      pg2.noStroke();
        
    float randomColor = random(-1,1);
    float rectWidth = random(15,10);
    
    if(randomColor < 0)
    { 
      
      if(OnHandPosition(hand) && hand != null)
      {
          out = myImage3.get((int)x+(int)random(-1.1,1.1), (int)y);
          rectWidth = random(20,15);
      }else{
          out = myImage2.get((int)x+(int)random(-1.1,1.1), (int)y);
      }
      
    } 
    else 
    {
      out = myImage.get((int)x, (int)y);
    }
    
    pg.fill(out,random(20,90));
    pg.rect(x,y, rectWidthFactor* rectWidth,rectHeightFactor*random(100,30));
    
  }

}

void leapOnInit() {
  
   println("Leap Motion Init");
}

void leapOnConnect() {
  
   println("Leap Motion Connect");
}

void leapOnFrame() {
  
}

void leapOnDisconnect() {
  
}

void leapOnExit() {
  
   println("Leap Motion Exit");
}

public boolean OnHandPosition(Hand leapHand){
  if(leapHand == null) return false;
  
  return (abs(x - leapHand.getPalmPosition().x) < userRange);
}

public boolean CanDrawRect(){
  return !(abs(x - treePosX) < userRange);
}

public boolean CanDrawRect2(){
  return !(abs(x - treePosX2) < userRange2);
}

public boolean CanDrawRect3(){
  return !(abs(x - mouseX) > userRange);
}


float controlUserRange = 0;
float controlTreePosX = 0;

float controlWidthFactor = 0;

/*void keyPressed() {
  switch(keyCode)
  {
    case UP:
      controlUserRange++;
      userRange = map(controlUserRange, 0, 127, 0, width / 2);
    break;
    case DOWN:
      controlUserRange--;
      userRange = map(controlUserRange, 0, 127, 0, width / 2);
    break;
    case LEFT:
      controlTreePosX--;
      treePosX = map(controlTreePosX, 0, 127, 0, width);
    break;
    case RIGHT:
      controlTreePosX++;
      treePosX = map(controlTreePosX, 0, 127, 0, width);
    break;
    case ENTER:
      controlWidthFactor--;
      rectWidthFactor = map(controlWidthFactor, 1, 127, 0.2, 1);
    break;
    case ALT:
      controlWidthFactor++;
      rectWidthFactor = map(controlWidthFactor, 1, 127, 0.2, 1);
    break;
  }
}*/
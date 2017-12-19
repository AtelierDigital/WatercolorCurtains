import themidibus.*;
import processing.sound.*;
import de.voidplus.leapmotion.*;

MidiBus myBus; // The MidiBus

float a = 0;
PImage myImage, myImage2, myImage3, myImage4;
PGraphics pg;
PGraphics pg2;

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

SoundFile windSound;
SoundFile jungleMorning;

LeapMotion leapMotion;

void setup() 
{
  //  MIDI stuff
  myBus = new MidiBus(this, "Arturia MINILAB", -1);
  
  windSound = new SoundFile(this, "/Sounds/WindBlows.mp3");
  jungleMorning = new SoundFile(this, "/Sounds/JungleMorning.mp3");
  
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
  
  windSound.play(0.5, 0.3);  
  jungleMorning.play(0.8,1.0);
  
  frameRate(30);
  
  leapMotion = new LeapMotion(this);
}

void draw() 
{
  
  pg.beginDraw();
  
  int count = 0;
      color myColor = 0;
    
  if(leapMotion.getHands ().size() > 0){
    for (Hand hand : leapMotion.getHands ()) {
      float ratio = map(hand.getPalmPosition().y, -300 , 800, 0.2, 1.2);  
      userRange = 70 * (ratio * ratio);
      rectHeightFactor = (ratio /ratio / ratio);
      rectWidthFactor = map(ratio, 0.2 , 1.2, 0.5, 0.7);  
      
      PickColor(hand, myColor);
      println("HAND"+count+" :"+hand.getPalmPosition().x);
      count++;
    }
  } 
  else
  {
    PickColor(null,myColor); 
  }
  
  
  pg.endDraw();
  
  image(pg,0,0);
   
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
    float rectWidth = random(10,5);
    
    if(randomColor < 0)
    { 
      
      if(OnHandPosition(hand) && hand != null)
      {
          out = myImage3.get((int)x+(int)random(-1.1,1.1), (int)y);
         // rectWidth = random(7,3);
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

//  MIDI stuff
void controllerChange(int channel, int number, int value) {
  
  println("userFactor = " + number);
  // Receive a controllerChange
  switch(number)
  {
    case 74:
      treePosX = map(value, 0, 127, 0, width/2);
      println("rectWidthFactor = " + rectWidthFactor);
    break;
    case 71:
      userRange = map(value, 0, 127, 0, width / 2);
    break;
    case 76:
      treePosX2 = map(127 - value, 0, 127, width/2, width);
    break;
     case 77:
      userRange2 = map(value, 0, 127, 0, width / 2);
    break;
    case 7:
      rectWidthFactor = map(value, 0, 127, 0.2, 1);
    break;
    case 114:
      rectHeightFactor = map(value, 0, 127, 0.2, 1);
    break;
    
    
  }
  println("Controller Change (channel, number, value):" + channel + " " + number + " " + value);
  /*println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);*/
}

float controlUserRange = 0;
float controlTreePosX = 0;

float controlWidthFactor = 0;

void keyPressed() {
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
}
import themidibus.*;

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

void setup() 
{
  //  MIDI stuff
  myBus = new MidiBus(this, "Arturia MINILAB", -1);
  
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
  
  frameRate(30);
}

void draw() 
{
  
  pg.beginDraw();
  
  UpdateRects();
  
  pg.endDraw();
  
  image(pg,0,0);
   
}

public void UpdateRects()
{ 
  color mycolor;
    
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
      if(!CanDrawRect() || !CanDrawRect2())
      {
        mycolor = myImage3.get((int)x+(int)random(-1.1,1.1), (int)y);
        rectWidth = random(20,10);
      }
      else 
      {
        mycolor = myImage2.get((int)x+(int)random(-1.1,1.1), (int)y);
      }
    } 
    else 
    {
      mycolor = myImage.get((int)x, (int)y);
    }
    
    pg.fill(mycolor,random(20,90));
      
    pg.rect(x,y, rectWidthFactor*random(rectWidth,5),rectHeightFactor*random(100,30));
  }
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
import themidibus.*;


MidiBus myBus; // The MidiBus


float a = 0;
PImage myImage, myImage2, myImage3;
PGraphics pg;

float x,y;

int nrects = 150;
float nRectsPercentage =1.0f;
float rectWidthFactor = 0.5;
float userFactor = 1;
float userRange = 100;

PImage mask;

void setup() 
{
  //  MIDI stuff
  myBus = new MidiBus(this, "Arturia MINILAB", -1);
  
  size(1920, 1080);
  pg = createGraphics(width, height);
  
  myImage = loadImage("IMG_3237.jpg").get(0,0, 1500,1080);
  myImage.resize(width,height);
  
  myImage2 = loadImage("forest.jpg").get(0,0, 1500,1080);
  myImage2.resize(width,height);
  
  myImage3 = loadImage("The_Shadow_Figure.jpg");
  
  
  image(myImage,0,0);
  
  mask = new PImage();  
}

void draw() 
{
  
  pg.beginDraw();
  
  //mask = myImage3.get(mouseX,0, (int)userRange,height);
  
 // pg.image(mask, mouseX,0);
  
  UpdateRects();
  
  pg.endDraw();
  
  image(pg,0,0);
   
}

public void UpdateRects()
{  
  color mycolor;
  
  /*int nregions = 3;
  for(int r=0; r<nregions; r++)
  {
     
  }*/
  
  PImage picImage = myImage;
  
  /*if(!CanDrawRect()){
    picImage = myImage3;
  }*/
  
  for(int i =0; i< nrects; i++)
  {
    x = random(0, picImage.width);
    y = random(0, picImage.height);
    pg.noStroke();
    
    float randomColor = random(-1,1);
    
    mycolor = picImage.get((int)x, (int)y);
    
    if(randomColor < 0)
    {
      mycolor = myImage2.get((int)x+(int)random(-1.1,1.1), (int)y);
    }
     
     
    /*if(!CanDrawRect()){*///
      pg.fill(mycolor,random(20,90));
      pg.rect(x,y, rectWidthFactor*random(15,5),random(60,20));
    //}     
  }
}

public boolean CanDrawRect(){
  return !(abs(x - mouseX) < userRange);
}

//  MIDI stuff
void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  switch(number)
  {
    case 7:
      userRange = map(value, 0, 127, 0, width / 2);
      println("userFactor = " + userFactor);
    break;
    case 74:
      rectWidthFactor = map(value, 0, 127, 0, 1);
      println("rectWidthFactor = " + rectWidthFactor);
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
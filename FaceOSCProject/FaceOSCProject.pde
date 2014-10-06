//
// a template for receiving face tracking osc messages from
// Kyle McDonald's FaceOSC https://github.com/kylemcdonald/ofxFaceTracker
//
// 2012 Dan Wilcox danomatika.com
// for the IACD Spring 2012 class at the CMU School of Art
//
// adapted from from Greg Borenstein's 2011 example
// http://www.gregborenstein.com/
// https://gist.github.com/1603230
//
import oscP5.*;
OscP5 oscP5;

ArrayList<ZoomLine> zoomers;
ZoomLine guy;

// num faces found
int found;

// pose
float poseScale;
PVector posePosition = new PVector();
PVector poseOrientation = new PVector();

// gesture
float mouthHeight;
float mouthWidth;
float eyeLeft;
float eyeRight;
float eyebrowLeft;
float eyebrowRight;
float jaw;
float nostrils;

void setup() {
  size(640, 480);
  frameRate(30);
  zoomers = new ArrayList<ZoomLine>();
  
  guy = new ZoomLine(50,50,200,200,10);
  
  oscP5 = new OscP5(this, 8338);
  oscP5.plug(this, "found", "/found");
  oscP5.plug(this, "poseScale", "/pose/scale");
  oscP5.plug(this, "posePosition", "/pose/position");
  oscP5.plug(this, "poseOrientation", "/pose/orientation");
  oscP5.plug(this, "mouthWidthReceived", "/gesture/mouth/width");
  oscP5.plug(this, "mouthHeightReceived", "/gesture/mouth/height");
  oscP5.plug(this, "eyeLeftReceived", "/gesture/eye/left");
  oscP5.plug(this, "eyeRightReceived", "/gesture/eye/right");
  oscP5.plug(this, "eyebrowLeftReceived", "/gesture/eyebrow/left");
  oscP5.plug(this, "eyebrowRightReceived", "/gesture/eyebrow/right");
  oscP5.plug(this, "jawReceived", "/gesture/jaw");
  oscP5.plug(this, "nostrilsReceived", "/gesture/nostrils");
}

void draw() {  
  background(255);
  stroke(0);
  makeZoomer();
  
  
  
  if(found > 0) {
    translate(posePosition.x, posePosition.y);
    scale(poseScale);
    rotateX(radians(poseOrientation.x));
    rotateY(radians(poseOrientation.y));
    drawLines();
  }
}

// OSC CALLBACK FUNCTIONS

public void found(int i) {
  println("found: " + i);
  found = i;
}

public void poseScale(float s) {
  println("scale: " + s);
  poseScale = s;
}

public void posePosition(float x, float y) {
  println("pose position\tX: " + x + " Y: " + y );
  posePosition.set(x, y, 0);
}

public void poseOrientation(float x, float y, float z) {
  println("pose orientation\tX: " + x + " Y: " + y + " Z: " + z);
  poseOrientation.set(x, y, z);
}

public void mouthWidthReceived(float w) {
  println("mouth Width: " + w);
  mouthWidth = w;
}

public void mouthHeightReceived(float h) {
  println("mouth height: " + h);
  mouthHeight = h;
}

public void eyeLeftReceived(float f) {
  println("eye left: " + f);
  eyeLeft = f;
}

public void eyeRightReceived(float f) {
  println("eye right: " + f);
  eyeRight = f;
}

public void eyebrowLeftReceived(float f) {
  println("eyebrow left: " + f);
  eyebrowLeft = f;
}

public void eyebrowRightReceived(float f) {
  println("eyebrow right: " + f);
  eyebrowRight = f;
}

public void jawReceived(float f) {
  println("jaw: " + f);
  jaw = f;
}

public void nostrilsReceived(float f) {
  println("nostrils: " + f);
  nostrils = f;
}

// all other OSC messages end up here
void oscEvent(OscMessage m) {
  
//  /* print the address pattern and the typetag of the received OscMessage */
//  println("#received an osc message");
//  println("Complete message: "+m);
//  println(" addrpattern: "+m.addrPattern());
//  println(" typetag: "+m.typetag());
//  println(" arguments: "+m.arguments()[0].toString());
  
  if(m.isPlugged() == false) {
    println("UNPLUGGED: " + m);
  }
}


void makeZoomer() {
  if (found > 0) {
      if ((eyebrowLeft > 8.8) && (eyebrowLeft > 8.8)) {
          zoomers.add(new ZoomLine(random(width) / poseScale, random(height) / poseScale ,
                        random(width) / poseScale, random(height) / poseScale, int(random(10,20))));
      }
  }
}
  
void drawLines() {
  for (int i = 0; i < zoomers.size(); i++) {
    zoomers.get(i).drawMe();
    zoomers.get(i).update();
  }
}

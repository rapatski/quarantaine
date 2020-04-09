
import peasy.*;
import geomerative.*;

import java.util.Map;
import java.util.Iterator;

/*

  // TODO:
  - Finish event implementation
    - Add "celebration" event-animation
    - Add photo display to celebration event
  - Add compass
 
 */


PeasyCam cam;
KeyScroller scroller;
EventSystem events;

PFont font;
PImage planeImg;

StringDict keywords;
RShape continents;

String currentWord = "";
int currentWordIndex = -1;
int lastWordIndex = -1;

boolean askNewQuestion = true;
boolean haveLanded = false;
boolean doCelebration = false;

boolean isAnimating = false;
boolean showPicture = false;

// --

String map_url = "Location_of_Continents.svg";
//String map_url = "World-Equirectangular.svg";

int polygonizer_precision = 1;

//int targetHeight = 1200;

void settings()
{
  fullScreen(P3D);

  //pixelDensity(2);
  smooth(8);
}

void setup() {

  // setup
  //cam = new PeasyCam(this, 500);
  font = createFont("Helvetica-Bold", 120); //loadFont("Orator-24.vlw");
  textFont(font);

  planeImg = loadImage("red_arrow.png");

  // perspective
  float fov = PI/3.0;
  float nearClip = 0.001;
  float farClip = 3000;

  float aspect = width/float(height);
  perspective(fov, aspect, nearClip, farClip);

  // geometry
  RG.init(this);
  RG.ignoreStyles(true);

  //RG.setPolygonizer(RG.ADAPTATIVE);
  RG.setPolygonizerStep(polygonizer_precision);
  RG.setPolygonizer(RG.UNIFORMSTEP);

  continents = RG.loadShape(map_url);
  continents.polygonize();

  float scaleY = height / continents.height * 1.5;
  //float scaleX = targetWidth / continents.width;

  continents.scale(scaleY);

  // set mappings
  keywords = new StringDict();
  for (int i = 0; i < continents.countChildren(); i++) 
  {
    // get name
    String keyword = continents.children[i].name;
    String label = keyword.toUpperCase();
    label = join(label.split("_"), " ");

    println(i + ": "+keyword+" - "+label);

    keywords.set(keyword, label);
  }

  // events
  events = new EventSystem();

  scroller = new KeyScroller(-1169.5812, -223.18999, 0); // england
}

void draw() {

  surface.setTitle("MAP GAME (FPS: "+nf(frameRate, 2, 1)+")");

  // events
  events.update(frameCount);

  // new assignment?
  if (askNewQuestion)
  {
    // get random new continent that isn't the same as the current one
    lastWordIndex = currentWordIndex;
    currentWordIndex = getNewRandomIndex(currentWordIndex, keywords.size());
    currentWord = keywords.get(keywords.key(currentWordIndex));

    say(currentWord);

    askNewQuestion = false;
  }


  // setup
  background(0, 0, 120);
  noCursor();

  // shape
  pushMatrix();

  PVector offset = new PVector(width/2 + scroller.x(), height/2 + scroller.y());
  translate(offset.x, offset.y);

  stroke(255);
  fill(50);
  continents.draw();
  RPoint p = new RPoint(-scroller.x(), -scroller.y());
  for (int i = 0; i < continents.countChildren(); i++) 
  {
    if (continents.children[i].contains(p)) 
    {
      RG.ignoreStyles(true);
      fill(255);
      if (i == currentWordIndex && haveLanded) {
        // whoop we got it! celebrate!
        int tNow = frameCount;
        String label = continents.children[i].name+"_success";
        events.add(tNow, label, 60, new Color(0, 255, 0));

        askNewQuestion = true;
      }
      if (i == lastWordIndex) 
      {

        fill(255, 255, 0);
      }

      if (doCelebration)
        fill(0, 255, 0);

      noStroke();
      continents.children[i].draw();
    }
  }

  scroller.update();

  popMatrix();

  // the player

  pushMatrix();

  translate(width/2, height/2);
  rotate(PI + vectorToRotation(scroller.getDirection()));


  boolean showPlane = true;
  noStroke();

  if (showPlane)
  { 
    rotate(PI/2);
    imageMode(CENTER);
    image(planeImg, 0, 0, 60, 60);
  } else {
    float sze = 10;
    float incr = TWO_PI/float(3);
    fill(255, 0, 0);
    beginShape();
    for (int i = 0; i < 3; i++) {
      float x = sze*cos(incr*i);
      float y = sze*sin(incr*i);
      vertex(x, y);
    }

    endShape(CLOSE);
  }

  popMatrix();

  // text overlay
  textAlign(CENTER, TOP);
  fill(255, 255, 0);
  text(currentWord, 0, 100, width - 60*2, height - 60*2);
}

void keyPressed() {
  scroller.handleKeyPresses(key);

  if (key == ' ')
  {
    haveLanded = true;
  }
}


void keyReleased() {
  scroller.handleKeyReleased(key);

  haveLanded = false;
}

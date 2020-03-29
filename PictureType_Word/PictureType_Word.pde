/*
~ Author: Tiemen Rapati
~ Date: March 2020
~ License: Free use (CC0)

This simple game was designed to enthuse my son (2yo at the time, 
now 4) to learn the alphabet and the concept of sequence. The game 
speaks every letter or number you type, and rewards a matching 
sequence of letters with a photo from the database.

<space bar> resets the currently typed string
<enter> speaks the currently typed string, even if it isn't a match
<backspace> shortens the string, like backspace should

Feel free to add more images and words by adding the image to the 
/images/ dir, and add the corresponding keyword/filename combo to
the text file in the /keywords/ folder. 

*/

PFont font;
PImage image;
StringDict keywords;

String tableFilename = "general.txt";

char[] alphabet = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
char[] numbers = {'1', '2', '3', '4', '5', '6', '7', '8', '9', '0'};

String currentString = "";
int currentImageIndex = 0;

boolean isAnimating = false;
boolean showPicture = false;

int tAnimStart = -1;
int tAnimEnd = -1;

int tAnimLength = 40;

void setup()
{
  fullScreen();

  font = createFont("Helvetica-Bold", 300);
  textFont(font);

  keywords = new StringDict();
  Table raw = loadTable("keywords/"+tableFilename, "header, csv");
  for (TableRow row : raw.rows()) {

    String keyword = trim(row.getString("KEYWORD")).toLowerCase();
    String image = trim(row.getString("IMAGE"));

    keywords.set(keyword, image);
  }
  println(keywords);

  imageMode(CENTER);

}

void draw()
{
  noCursor();
  
  // background colour
  colorMode(RGB, 255, 255, 255);

  if (frameCount*3 < 255)
    background(frameCount*3, 255, frameCount*3); // display green flash when loaded
  else
    background(255);

  // background image
  if (showPicture)
  {
    background(0, 0, 0);
    image(image, width/2, height/2);
  }
  
  // text 
  textAlign(CENTER, CENTER);

  if (isAnimating)
  {
    // animating
    renderTextAnimation();
  } 
  else if(showPicture)
  {
    // white overlay
    fill(255, 200);
    text(currentString.toUpperCase(), 60, 60, width - 60*2, height - 60*2);
  }
  else
  {
    // black
    fill(0);
    text(currentString.toUpperCase(), 60, 60, width - 60*2, height - 60*2);
  }
}

void keyReleased()
{
  if (isAnimating)
    return; // no keys when animating
    
  if (showPicture) {
    // if in show picture mode, any keypress will reset state
    showPicture = false;
    currentString = "";
    return;
  }

  if (key == ' ') {
    // space bar resets
    currentString = "";
    return;
  }

  if (key == ENTER) {
    // enter speaks string, just for fun
    say(currentString);
    currentString = "";
    return;
  }

  if (key == BACKSPACE && currentString.length() > 0) {
    // backspace 
    currentString = currentString.substring(0, currentString.length()-1);
    return;
  }

  key = str(key).toLowerCase().charAt(0);

  if (charExists(alphabet, key) || charExists(numbers, key))
  {
    // if letter or number, add key to current string
    currentString += key;

    say(str(key));
  }

  if (keywords.hasKey(currentString))
  {
    // it's a match, wohoo!
    triggerTextAnimation();
    println("bingo: "+currentString);
  }
}

void triggerTextAnimation()
{
  tAnimStart = frameCount;
  tAnimEnd = frameCount + tAnimLength;

  isAnimating = true;
}

void renderTextAnimation()
{
  float t = (frameCount - tAnimStart) / float(tAnimLength);
  
  if (frameCount > tAnimEnd) {
    isAnimating = false;
    showPicture = true;
    image = loadImageResize("images/"+keywords.get(currentString), width, height);

    say(currentString);
  }
  
  colorMode(HSB, 360, 255, 255);
  float h = 180 + t*180;

  fill(h, 255, 255);// - constrain(255 * (1-t), 0, 255));
  text(currentString.toUpperCase(), 60, 60, width - 60*2, height - 60*2);

  colorMode(RGB, 255, 255, 255);
}

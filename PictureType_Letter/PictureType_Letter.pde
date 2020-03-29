/*
~ Author: Tiemen Rapati
~ Date: March 2020
~ License: Free use (CC0)

This game lets MacOS speak a word, prompting the player (3 or 4yo)
to type the first letter of that word. If they get it right, they
get rewarded by a picture of that word.

<space bar> repeats the current word

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
String currentWord = "";
int currentWordIndex = 0;

boolean askNewQuestion = true;
boolean isAnimating = false;
boolean showPicture = false;

int tAnimStart = -1;
int tAnimEnd = -1;

int tAnimLength = 40;

void setup()
{
  fullScreen();

  font = createFont("Helvetica-Bold", 500);
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
  // -- update
  
  if(askNewQuestion)
  {
    currentWordIndex = int(random(keywords.size()));
    currentWord = keywords.key(currentWordIndex);
    
    say(currentWord);
    
    currentString = "";
    askNewQuestion = false;
  }
  
  
  // -- draw
  
  noCursor();
  
  // background colour
  colorMode(RGB, 255, 255, 255);
  
  if (frameCount*3 < 255)
    background(0, 255 - frameCount*3, 255 - frameCount*4);
  else
    background(0);


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
    text(currentString, 60, 60, width - 60*2, height - 60*2);
  }
  else
  {
    // white
    fill(255);
    text(currentString, 60, 60, width - 60*2, height - 60*2);
  }
}

void keyReleased()
{
  if (isAnimating || askNewQuestion)
    return; // no keys when animating

  if (key == ' ' && !showPicture) {
    // repeat word by pressing space bar
    say(currentWord);
    return;
  }

  if (showPicture) 
  {
    // if in show picture mode, any keypress will reset state and trigger new word
    showPicture = false;
    currentString = "";
    
    askNewQuestion = true;
    return;
  }

  key = str(key).toLowerCase().charAt(0);

  if (charExists(alphabet, key))
  {
    // if letter, add lowercase and uppercase to displayed text
    currentString = str(key).toUpperCase() + str(key);

    if(currentWord.charAt(0) == key) 
    {
      // letter matches the first letter of the word, wohoo!
      triggerTextAnimation();
      println("bingo: "+currentString);
    }

    say(str(key));
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
    image = loadImageResize("images/"+keywords.get(currentWord), width, height);

    String[] params = {
      "say", currentWord
    };
    exec(params);
  }
  
  colorMode(HSB, 360, 255, 255);
  float h = 180 + t*180;
  
  
  fill(h, 255, constrain(255 * (1-t)*4, 0, 255));
  text(currentString, 60, 60, width - 60*2, height - 60*2);

  
  colorMode(RGB, 255, 255, 255);
}

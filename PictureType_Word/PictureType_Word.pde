

PFont font;
PImage image;
StringDict keywords;

String tableFilename = "max.txt";

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

  font = createFont("Futura-Medium", 300);
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

  //image = loadImage("images/"+words[currentImageIndex]+".png");
}

void draw()
{
  if (frameCount*3 < 255)
    background(frameCount*3, 255, frameCount*3);
  else
    background(255);

  colorMode(RGB, 255, 255, 255);

  textAlign(CENTER, CENTER);
  noCursor();
  

  if (showPicture)
  {
    background(0, 0, 0);
    //currentString = "";
    image(image, width/2, height/2);
  }
  
  if (isAnimating)
  {
    renderTextAnimation();
  } else
  if(showPicture)
  {
    fill(255, 200);
    text(currentString.toUpperCase(), 60, 60, width - 60*2, height - 60*2);
  }
  else
  {
    fill(0);
    text(currentString.toUpperCase(), 60, 60, width - 60*2, height - 60*2);
  }
}

void keyReleased()
{
  if (showPicture) {

    showPicture = false;
    currentString = "";
    return;
  }

  if (isAnimating)
    return;

  if (key == ' ') {
    currentString = "";
    return;
  }

  if (key == ENTER) {
    String[] params = {
      "say", currentString
    };
    exec(params);
    currentString = "";
    return;
  }

  if (key == BACKSPACE && currentString.length() > 0) {
    currentString = currentString.substring(0, currentString.length()-1);
    return;
  }

  key = str(key).toLowerCase().charAt(0);

  if (charExists(alphabet, key) || charExists(numbers, key))
  {
    currentString += key;

    String[] params = {
      "say", str(key)
    };
    exec(params);
  }

  if (keywords.hasKey(currentString))
  {


    triggerTextAnimation();
    println("bingo: "+currentString);
  }
}

boolean charExists(char[] arr, char val) {

  boolean exists = false;

  for (int i = 0; i < arr.length; i++) {
    if (byte(arr[i]) == byte(val)) {
      exists = true;
    }
  }

  return exists;
}

int indexOfString(String[] arr, String val) {

  int index = -1;

  for (int i = 0; i < arr.length; i++) {
    if (arr[i].equals(val)) {
      index = i;
    }
  }

  return index;
}

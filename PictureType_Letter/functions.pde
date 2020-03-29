PImage loadImageResize(String path, int maxW, int maxH)
{
  PImage img = loadImage(path);
  colorMode(RGB, 255, 255, 255);
  
  if(img == null)
    img = createImage(1, 1, ARGB);

  // determine whether image is portrait or landscape
  boolean portrait = ( img.height / img.width >= 1 );
  println("loading "+path+": portrait["+portrait+"] ("+(img.width / img.height)+")");

  // depending on orientation, scale to max dimensions
  int w = (portrait) ? int(img.width / float(img.height) * maxH) : maxW;
  int h = (portrait) ? maxH : int(img.height / float(img.width) * maxW);
  
  println(img.width);
  println(img.height);
  
  img.resize(w, h);

  return img;
}

void triggerTextAnimation()
{
  tAnimStart = frameCount;
  tAnimEnd = frameCount + tAnimLength;

  isAnimating = true;
}

void askQuestion()
{
  String[] params = {
      "say", currentWord
    };
    exec(params);
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

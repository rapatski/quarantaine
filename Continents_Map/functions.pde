int getNewRandomIndex(int currentIndex, int arrayLength)
{
  int newWordIndex = currentIndex;
    int safe = 0;
    while(currentIndex == newWordIndex && safe < 1000) {
      newWordIndex = int(random(arrayLength));
      safe++;
    }
    return newWordIndex;
}



float vectorToRotation(PVector v)
{
  float dot = PVector.dot(new PVector(1, 0, 0), v);
  float rot = (v.y >= 0) ? (1f - dot) / 4f : (dot + 3f) / 4f;
  return rot * TWO_PI;
}

void say(String string)
{
  String[] params = {
      "say", string
    };
    exec(params);
}

PImage loadImageResize(String path, int maxW, int maxH)
{
  PImage img = loadImage(path);  
  if(img == null)
    img = createImage(1, 1, ARGB);

  // determine whether image is portrait or landscape
  boolean portrait = ( img.height / img.width >= 1 );

  // depending on orientation, scale to max dimensions
  int w = (portrait) ? int(img.width / float(img.height) * maxH) : maxW;
  int h = (portrait) ? maxH : int(img.height / float(img.width) * maxW);
  img.resize(w, h);

  return img;
}

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

boolean charExists(char[] arr, char val) 
{
  boolean exists = false;
  for (int i = 0; i < arr.length; i++) 
  {
    if (byte(arr[i]) == byte(val))
      exists = true;
  }

  return exists;
}

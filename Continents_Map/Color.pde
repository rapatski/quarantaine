class Color
{
  color col;
  float[] rgba = new float[4];
  float r, g, b, a;

  Color(int r, int g, int b) 
  {
    this.r = rgba[0] = r;
    this.g = rgba[1] = g;
    this.b = rgba[2] = b;
    this.a = rgba[3] = 255;
  }
  
  Color(int r, int g, int b, int a) 
  {
    this.r = rgba[0] = r;
    this.g = rgba[1] = g;
    this.b = rgba[2] = b;
    this.a = rgba[3] = a;
  }
  
  Color(color c) 
  {
    col = c;
    r = rgba[0] = c >> 16 & 0xFF;
    g = rgba[1] = c >> 8 & 0xFF;
    b = rgba[2] = c & 0xFF;
    a = rgba[3] = alpha(c);
  }
  
  Color(Color c) 
  {
    col = color(c.r, c.g, c.b, c.a);
    r = rgba[0] = c.r;
    g = rgba[1] = c.g;
    b = rgba[2] = c.b;
    a = rgba[3] = c.a;
  }

  color mapColor(Color mincolor, Color maxcolor, float value, float minvalue, float maxvalue) {

    float r, g, b;
    float dr, dg, db;

    float time = (value - minvalue) / (maxvalue - minvalue);

    dr = maxcolor.r - mincolor.r;
    dg = maxcolor.g - mincolor.g;
    db = maxcolor.b - mincolor.b;

    r = mincolor.r + time*dr;
    g = mincolor.g + time*dg;
    b = mincolor.b + time*db;

    color c = color(r, g, b);
    return c;
  }
  
  color mapTo(Color maxcolor, float value, float minvalue, float maxvalue) {

    float r, g, b;
    float dr, dg, db;

    float time = (value - minvalue) / (maxvalue - minvalue);

    dr = maxcolor.r - this.r;
    dg = maxcolor.g - this.g;
    db = maxcolor.b - this.b;

    r = this.r + time*dr;
    g = this.g + time*dg;
    b = this.b + time*db;

    color c = color(r, g, b);
    return c;
  }
}

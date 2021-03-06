int greenDistance = 200;
int componentDiff = 0;

void key (PImage src, PImage result) {
  src.loadPixels ();
  result.loadPixels ();
  int pixelLocation;

  PVector currentPixel = new PVector (0, 0, 0);
  PVector greenPixel = new PVector (0, 255, 0);

  for (int originalY = 0; originalY < src.height; originalY++) {
    for (int originalX = 0; originalX < src.width; originalX++) {
      pixelLocation = originalX + originalY * src.width;

      color c = src.pixels [pixelLocation];
      currentPixel.x = red (c); currentPixel.y = green (c); currentPixel.z = blue (c);

      if (PVector.dist (greenPixel, currentPixel) <= greenDistance &&
          max (currentPixel.x, currentPixel.z) - currentPixel.y < componentDiff) {
        result.pixels [pixelLocation] = color (0, 0, 0, 0);
        // result.pixels [pixelLocation] = src.pixels [pixelLocation];
      } else {
        result.pixels [pixelLocation] = src.pixels [pixelLocation];
      }
    }
  }

  result.updatePixels ();
}

PImage src;
PImage result;

void keyPressed () {
  switch (key) {
    case '+':
      greenDistance++;
      break;
    case '-':
      greenDistance--;
      break;
    case 'k':
      componentDiff++;
      break;
    case 'j':
      componentDiff--;
      break;
    case 'n':
      imgIndex++;
      imgIndex %= images.length;
      setupImages ();
      break;
  }

  keyed = false;
}

String [] images;
boolean keyed = false;

void setup () {
  size (800, 600);
  imgIndex = 0;

  images = new File ("data/pics").list ();
  setupImages ();
}

int imgIndex;
void setupImages () {
  src = loadImage ("pics/" + images [imgIndex]);
  src.resize (300, 0);

  result = createImage (src.width, src.height, ARGB);
  key (src, result);

  src.updatePixels ();
  result.updatePixels ();

  textFont (loadFont ("fonts/archer.vlw"), 15);
}

void draw () {
  background (255, map (sin ((float)millis () / 200.0), -1, 1, 128, 255), map (cos ((float)millis () / 200.0), -1, 1, 128, 255));
  translate ((width - src.width * 2) / 2, (height - (src.height)) / 2);

  image (src, 0, 0, src.width, src.height);

  translate (src.width + 10, 0);

  image (result, 0, 0, result.width, result.height);

  translate (0, result.height + 10);

  fill (0);
  text ("Current distance is: " + greenDistance, 0, 0);
  text ("Current component distance: " + componentDiff, 0, 20);
  text ("Currently viewing image: " + imgIndex, 0, 40);

  if (!keyed) {
    key (src, result);
    keyed = true;
  }


  // greenDistance = ceil (map (sin ((float)millis () / 500.0), -1, 1, 100, 250));
}

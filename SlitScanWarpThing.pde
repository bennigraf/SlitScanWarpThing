/**
 * Time-Warping Slitscan-like effect thing 
 * By Benjamin Graf.
 *
 * Idea based on William Forsythe's "City of Abstracts" 
 */
 
import processing.video.*;
Capture video;

int camWidth = 640;
int camHeight = 360;

float lineDrawHeight;
float ceiledLineDrawHeight;

ArrayList<color[]>[] lines = new ArrayList[camHeight];

PGraphics outBuffer;

void setup() {
  size(640, 360, P2D);
  //fullScreen(P2D);
  
  lineDrawHeight = height / (float)camHeight;
  ceiledLineDrawHeight = ceil(lineDrawHeight);
  
  for (int i = 0; i < camHeight; i++) {
    ArrayList<color[]> line = new ArrayList<color[]>();
    for (int j = 0; j <= i; j++) {
      line.add(new color[camWidth]);
    }
    lines[i] = line;
  }
  
  outBuffer = createGraphics(camWidth, camHeight, P2D);
  
  video = new Capture(this, camWidth, camHeight, 30);
  
  video.start();  

  background(0);
}

int framecounter = 0;

void draw() {
  if (video.available()) {
    video.read();
    video.loadPixels();
    
    for (int i = 0; i < camHeight; i++) {
      int writeindex = framecounter % lines[i].size(); 
      arrayCopy(video.pixels, i * camWidth, lines[i].get(writeindex), 0, camWidth);
    }
    
    framecounter = framecounter + 1; 
  }
    
  outBuffer.loadPixels();
  for (int i = 0; i < camHeight; i++) {
    int readindex = (framecounter + 1) % lines[i].size();
    readindex = max(0, readindex);
    arrayCopy(lines[i].get(readindex), 0, outBuffer.pixels, i * camWidth, camWidth);
  }
  outBuffer.updatePixels();
  image(outBuffer, 0, 0, width, height);
}

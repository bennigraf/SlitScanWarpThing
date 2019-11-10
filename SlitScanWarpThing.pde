/**
 * Time-Warping Slitscan-like effect thing 
 * By Benjamin Graf.
 *
 * Idea based on William Forsythe's "City of Abstracts" 
 */
 
import processing.video.*;
Capture video;

int camWidth = 320;
int camHeight = 180;

float lineDrawHeight;
float ceiledLineDrawHeight;

ArrayList[] lines = new ArrayList[camHeight];

void setup() {
  size(640, 360);
  //fullScreen(P2D);
  
  lineDrawHeight = height / (float)camHeight;
  ceiledLineDrawHeight = ceil(lineDrawHeight);
  
  for (int i = 0; i < camHeight; i++) {
    //color[] buffer = new color[320];
    //ArrayList<color[]> line = new ArrayList<color[]>();
    ArrayList<PImage> line = new ArrayList<PImage>();
    for (int j = 0; j <= i/2; j++) {
      //line.add(new color[camWidth]);
      line.add(createImage(camWidth, 1, RGB));
    }
    lines[i] = line;
    //println(line.size());
    //println(line.get(0).length);
  }
  
  println(lines.length);
  
  for (int i = 0; i < lines.length; i++) {
    //println(lines[i].size());
    //println(lines[i][0].length);
  }
  
  // This the default video input, see the GettingStartedCapture 
  // example if it creates an error
  video = new Capture(this, camWidth, camHeight, 20);
  
  // Start capturing the images from the camera
  video.start();  

  background(0);
}

int framecounter = 0;

void draw() {
  if (video.available()) {
    video.read();
    video.loadPixels();
    
    for (int i = 0; i < camHeight; i++) {
      //println(lines[i].size());
      int writeindex = framecounter % lines[i].size(); 
      //arrayCopy(video.pixels, i * camWidth, lines[i].get(writeindex), 0, camWidth);
      PImage image = (PImage)lines[i].get(writeindex);
      image.loadPixels();
      arrayCopy(video.pixels, i * camWidth, image.pixels, 0, camWidth);
      image.updatePixels();
    }
    
    //loadPixels();
    
    for (int i = 0; i < camHeight; i++) {
      //copy(lines[i].get(0), 
      int readindex = (framecounter + 1) % lines[i].size();
      readindex = max(0, readindex);
      //arrayCopy(lines[i].get(readindex), 0, pixels, camWidth*i, camWidth);
      PImage image = (PImage)lines[i].get(readindex);
      image(image, 0, i * lineDrawHeight, width, ceiledLineDrawHeight);
      
    }
    
    //updatePixels();
    
    //image(video, 0, 0);
    framecounter = framecounter + 1;
  }
}

/**
 * Time-Warping Slitscan-like effect thing 
 * By Benjamin Graf.
 *
 * Idea based on William Forsythe's "City of Abstracts" 
 */
 
 
import processing.video.*;

Capture video;


int camHeight = 240;
int camWidth = 320;


ArrayList[] lines = new ArrayList[camHeight];

void setup() {
  size(320, 240);
  
  for (int i = 0; i < camHeight; i++) {
    //color[] buffer = new color[320];
    ArrayList<color[]> line = new ArrayList<color[]>();
    for (int j = 0; j <= i/2; j++) {
      line.add(new color[camWidth]);
    }
    lines[i] = line;
    //println(line.size());
    //println(line.get(0).length);
  }
  
  println(lines.length);
  
  for (int i = 0; i < lines.length; i++) {
    println(lines[i].size());
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
      arrayCopy(video.pixels, i * camWidth, lines[i].get(writeindex), 0, camWidth);
    }
    
    loadPixels();
    
    for (int i = 0; i < camHeight; i++) {
      //copy(lines[i].get(0), 
      int readindex = (framecounter + 1) % lines[i].size();
      readindex = max(0, readindex);
      arrayCopy(lines[i].get(readindex), 0, pixels, camWidth*i, camWidth);
    }
    
    updatePixels();
    
    //image(video, 0, 0);
    framecounter = framecounter + 1;
  }
}

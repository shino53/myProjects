import SimpleOpenNI.*;
SimpleOpenNI  kinect;      
int [] userMap;
import processing.video.*;
Movie myMovie;

void setup()
{
  size(640,480,P3D); 
  kinect = new SimpleOpenNI(this);
  if(kinect.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
 
  kinect.enableDepth();
  kinect.enableUser();
  background(0);
  noStroke();
  
  myMovie = new Movie(this, "movie.mov");
  myMovie.play();
  myMovie.loop();
  }
 
void draw()
{
  background(0);
  kinect.update();
 
  if( myMovie.available() == true ){
    myMovie.read();
    myMovie.loadPixels();
  }
 
  int[] userList = kinect.getUsers();
  if(userList.length>0){
    userMap = kinect.userMap();
    loadPixels();
    for(int i=0; i<userMap.length; i++){
      int w=(i%width); int h=(i/width);
      if(userMap[i]!=0){ pixels[i] =myMovie.get(w,h); }
       else{ pixels[i] = color(0);}
    }
    updatePixels();
  }
  //image(myMovie,800,0,200,150);
}

void keyPressed()
{
  switch(key)
  {
  case ' ':
    kinect.setMirror(!kinect.mirror());
    break;
  }
}

// -----------------------------------------------------------------
// SimpleOpenNI events

void onNewUser(SimpleOpenNI curContext, int userId)
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
}

void onLostUser(SimpleOpenNI curContext, int userId)
{
  println("onLostUser - userId: " + userId);
}

void onVisibleUser(SimpleOpenNI curContext, int userId)
{
  //println("onVisibleUser - userId: " + userId);
}

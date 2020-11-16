import SimpleOpenNI.*;
import ddf.minim.*;

SimpleOpenNI  context;
Minim minim;
AudioPlayer song;

PVector     com = new PVector();                                   
PVector     com2d = new PVector();
int[]            userMap;
color           a,b,c,d;    //衣装の色
int                l,l2;           //衣装の丈
int                Rhand[]  = new int[124];     //手の軌跡
int                hand;     //手の軌跡ログ用
float            fov = 45.0;                    // Kinectの垂直方向の視野角
float            z0 = 0;                        // 視点から画像平面までの距離
color[]        pixelBuffer = null;            // 描画内容を一時保存しておくためのバッファ
color           key_color = color(0);  // クロマキー合成用の背景色
float            angle = 0;                     // 回転角度
int                vertex_num = 3;
int               starttm;
int               MODE=0;

void setup()
{
  size(640,480,P3D);
  starttm = millis();  
  minim = new Minim( this );
  song = minim.loadFile( "song.mp3" );
  //song.play();
  
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  
  context.setMirror(false);
  context.enableDepth();
  context.enableUser();
  context.enableRGB();
  context.alternativeViewPointDepthToImage();
  context.setDepthColorSyncEnabled(true);
  
  a = color(random(0,255),random(0,255),random(0,255),100);
  b = color(random(0,255),random(0,255),random(0,255),100);
  c = color(random(0,255),random(0,255),random(0,255),100);
  d = color(random(0,255),random(0,255),random(0,255),100);
   l = l2 = (int)random(0,25);
   hand=1;
   pixelBuffer = new color[width * height]; 
   z0 = (height/2)/tan(radians(fov/2));        // 視点と画像平面までの距離
   
   
   smooth();  
}

void draw()
{
  int sabun = millis() - starttm;
  
  if(!song.isPlaying()){
    song.play(); 
    starttm = millis();
  }
  
  if(  sabun < 1000 * 20 ){ 
    MODE=0;
  } else if( sabun < 1000*57 ){
    MODE=1;
  } else if( sabun < 1000*72){
    MODE=2;
  } else if( sabun < 1000*97  || (sabun > 1000*102 && sabun < 1000*109)){
    MODE=3;
  } else if( sabun < 1000*102 ){
    MODE=4;
  } else if( sabun < 1000*(30+92) ){
    MODE=5;
  } else if( sabun < 1000*(30+110) ){
    MODE=6;
  }
  context.update();
  userMap = context.userMap();  
  int[] userList = context.getUsers();
  
  if(MODE==6){ //オクルージョン
      for(int i=0;i<userList.length;i++){
      context.getCoM(userList[i],com);
      drawObject();
    } 
      if(frameCount%40==0){vertex_num++;}
  }
  else{
  background(0,0,0);
  if(MODE!=5){ //人間を描画
    loadPixels();
    for(int y=0; y<context.rgbHeight(); y++){
      for(int x=0; x<context.rgbWidth(); x++){
        int i = x + y * context.rgbWidth();
        if(userMap != null && userMap[i] > 0){//draw user
          if(MODE==4){pixels[i]=color(random(255),random(255),random(255));}
          else{ pixels[i]=color(255);}
        }
      } 
    }
  }
  if(MODE==1){
    for(int i=0;i<userList.length;i++){
      context.getCoM(userList[i],com);
      context.convertRealWorldToProjective(com,com2d);
      drawIto(userList[i]); 
      drawDress(userList[i]);
    } 
  }
  else if(MODE==2){ 
    for(int i=0;i<userList.length;i++){
      context.getCoM(userList[i],com);
      context.convertRealWorldToProjective(com,com2d);
      drawDress(userList[i]);
    } 
  }
  else if(MODE==3){
      for(int i=0;i<userList.length;i++){
      context.getCoM(userList[i],com);
      context.convertRealWorldToProjective(com,com2d);
      drawRhand(userList[i]);
      hand+=2;
    } 
  }
  else if(MODE==5){
    for(int i=0;i<userList.length;i++){drawSkeleton(userList[i]); /* println("draw joint");*/} 
  }
    updatePixels(); 
  }
}


// -----------------------------------------------------------------
void drawIto(int userId)
{
  stroke(255);
  strokeWeight(2);
  PVector jointPos = new PVector();
  PVector jointPos2d = new PVector();
  int i;
  for(i=2;i<8;i++){ 
    context.getJointPositionSkeleton(userId,i,jointPos);
    context.convertRealWorldToProjective(jointPos,jointPos2d);
    line(jointPos2d.x, jointPos2d.y,jointPos2d.x, jointPos2d.y-height);
  }
  //simpleOpenNI 定数一覧: http://denki.nara-edu.ac.jp/~yabu/soft/processing.html
}

// -----------------------------------------------------------------
double getRadian(double x, double y, double x2, double y2) {
    double radian = Math.atan2(y2 - y,x2 - x);
    return radian;
}

void drawDress(int userId)
{
  noStroke();
  PVector jointPos_r = new PVector();
  PVector jointPos2d_r = new PVector();
  PVector jointPos_l = new PVector();
  PVector jointPos2d_l = new PVector();
  float rad;

  if(MODE==1){
    fill(221,160,221,100); 
    context.getJointPositionSkeleton(userId,2,jointPos_l);
    context.convertRealWorldToProjective(jointPos_l,jointPos2d_l);
    context.getJointPositionSkeleton(userId,3,jointPos_r);
    context.convertRealWorldToProjective(jointPos_r,jointPos2d_r);
    rad = (float)getRadian(jointPos2d_r.x,jointPos2d_r.y,jointPos2d_l.x,jointPos2d_l.y);
    arc(com2d.x,com2d.y-80,150,150,rad-PI,rad, OPEN);
    arc(com2d.x,com2d.y-80,150+random(-10,10),150+random(-10,10),rad-PI+random(-PI/8,PI/8),rad+random(-PI/8,PI/8), OPEN); //println(rad);
    context.getJointPositionSkeleton(userId,11,jointPos_l);
    context.convertRealWorldToProjective(jointPos_l,jointPos2d_l);  
    context.getJointPositionSkeleton(userId,12,jointPos_r);
    context.convertRealWorldToProjective(jointPos_r,jointPos2d_r);
    quad(com2d.x-20,com2d.y-50,com2d.x+20,com2d.y-50,jointPos2d_r.x+50,jointPos2d_r.y+30,jointPos2d_l.x-50,jointPos2d_l.y+30);
    quad(com2d.x-20,com2d.y-50,com2d.x+20,com2d.y-50,jointPos2d_r.x+50+random(-8,8),jointPos2d_r.y+30+random(-8,8),jointPos2d_l.x-50+random(-8,8),jointPos2d_l.y+30+random(-8,8));

}
  else{
    if(frameCount%10==0){
      a= color(random(0,255),random(0,255),random(0,255),100);
      b= color(random(0,255),random(0,255),random(0,255),100);
      c= color(random(0,255),random(0,255),random(0,255),100);
      d= color(random(0,255),random(0,255),random(0,255),100);
      l = (int)random(0,50);       l2 = (int)random(0,50);
    }
    fill(a);
    context.getJointPositionSkeleton(userId,2,jointPos_l);
    context.convertRealWorldToProjective(jointPos_l,jointPos2d_l);  
    quad(jointPos2d_l.x-25,jointPos2d_l.y-20,jointPos2d_l.x-25,com2d.y,com2d.x,com2d.y,com2d.x,jointPos2d_l.y-20);

    fill(b);
    context.getJointPositionSkeleton(userId,3,jointPos_r);
    context.convertRealWorldToProjective(jointPos_r,jointPos2d_r);
    quad(jointPos2d_r.x+25,jointPos2d_r.y-20,jointPos2d_r.x+25,com2d.y,com2d.x,com2d.y,com2d.x,jointPos2d_r.y-20);

    fill(c);
    context.getJointPositionSkeleton(userId,11,jointPos_l);
    context.convertRealWorldToProjective(jointPos_l,jointPos2d_l);  
    quad(jointPos2d_l.x-40,jointPos2d_l.y-l,com2d.x-50,com2d.y,com2d.x,com2d.y,com2d.x,jointPos2d_l.y-l);

    fill(d);
    l = (int)random(0,50);
    context.getJointPositionSkeleton(userId,12,jointPos_r);
    context.convertRealWorldToProjective(jointPos_r,jointPos2d_r);
    quad(jointPos2d_r.x+40,jointPos2d_r.y-l2,com2d.x+50,com2d.y,com2d.x,com2d.y,com2d.x,jointPos2d_r.y-l2);
  }
}

// -----------------------------------------------------------------
void drawRhand(int userId)
{
  PVector jointPos = new PVector();
  PVector jointPos2d = new PVector();
  context.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,jointPos);
  context.convertRealWorldToProjective(jointPos,jointPos2d);
  Rhand[0]=(int)jointPos2d.x;  Rhand[1]=(int)jointPos2d.y;
  
  if(hand >121){
      for(int i=2;i<116;i+=4){
        stroke(255,0,0,abs(120-i));
        strokeWeight(3);
        line(Rhand[i],Rhand[i+1],Rhand[i+4],Rhand[i+5]);
      }
     for(int i=120;  i>=0; i-=2){ 
        Rhand[i+2]=Rhand[i]; Rhand[i+3]=Rhand[i+1]; 
     }
  }
  else{
      for(int i=hand; i>0; i-=2){ Rhand[i+1]=Rhand[i-1]; Rhand[i+2]=Rhand[i];}
   }
}



// -----------------------------------------------------------------
void drawSkeleton(int userId)
{ 
  fill(0);
  rect(0,0,width,height);
  //background(0);
  stroke(255);
  strokeWeight((int)random(1,3));
  for(int i=0;i<50;i++){ context.drawLimb(userId,(int)random(0,14.9),(int)random(0,14.9)); }
  //simpleOpenNI 定数一覧: http://denki.nara-edu.ac.jp/~yabu/soft/processing.html
}


// -----------------------------------------------------------------
void drawDepth3D() {
  int steps = 2;
  strokeWeight(3);
  for (int y=0; y<context.depthHeight(); y+=steps) {
    for (int x=0; x<context.depthWidth(); x+=steps) {
      int index = x + y * context.depthWidth();
      if ( context.depthMap()[index] > 0) {
        PVector realWorldPoint = context.depthMapRealWorld()[index];
        point(realWorldPoint.x, realWorldPoint.y, realWorldPoint.z);
      }
    } 
  }  
}

void drawObject()
{
  background(key_color);
  perspective( radians(fov), float(width)/float(height), 1.0, 10000.0);
  camera( width/2, height/2, z0, width/2, height/2, 0.0, 0.0, 1.0, 0.0 );
  lights();
  pushMatrix();
    translate( width/2, height/2, z0); 
    rotateX(PI);
    pushMatrix();
      translate(com.x,com.y+400,com.z);
      rotateX(PI/2+angle/100); rotateZ(angle);
      fill(128, 128, 255);  stroke(128, 128, 255);  strokeWeight(5);
      beginShape(QUAD_STRIP);
      int R = 500;
      for (int i = 0; i <= vertex_num; i++) {
        int x = (int)(R * cos(radians(360/vertex_num * i)));
        int y = (int)(R * sin(radians(360/vertex_num * i)));
        int x2 = (int)((R*0.8) * cos(radians(360/vertex_num * i)));
        int y2 = (int)((R*0.8) * sin(radians(360/vertex_num * i)));
        vertex(x, y,300);
        vertex(x2, y2,300);
      }
      endShape();
      pushMatrix();
      translate(0,0,-100);
      beginShape(QUAD_STRIP);
      R = 500;
      for (int i = 0; i <= vertex_num; i++) {
        int x = (int)(R * cos(radians(360/vertex_num * i+0.1)));
        int y = (int)(R * sin(radians(360/vertex_num * i+0.1)));
        int x2 = (int)((R*0.8) * cos(radians(360/vertex_num * i+0.1)));
        int y2 = (int)((R*0.8) * sin(radians(360/vertex_num * i+0.1)));
        vertex(x, y,300);
        vertex(x2, y2,300);
      }
      endShape();
      popMatrix();
    popMatrix();
    noLights();
    stroke(key_color);
    drawDepth3D();  
  popMatrix();
  loadPixels();
  arrayCopy(pixels, pixelBuffer);
  background(0);
  image( context.rgbImage(), 0, 0 );

  // クロマキー合成
  loadPixels();
  for (int i = 0; i < width * height; i++) {
    if(!(userMap != null && userMap[i] > 0)){ pixels[i]= color(0); }
    if(userMap != null && userMap[i] > 0){  pixels[i]=color(255); }
    if (pixelBuffer[i] != key_color) { pixels[i] = pixelBuffer[i]; }
  }
  updatePixels(); 
  angle += 0.1; // 回転角度を更新
}


// -----------------------------------------------------------------
void stopsong()
{
  song.close();
  /*minim.stop();
  super.stop();*/
}


// -----------------------------------------------------------------
void onNewUser(SimpleOpenNI curContext, int userId)  // SimpleOpenNI events
{
  println("onNewUser - userId: " + userId);
  println("\tstart tracking skeleton");
  
  curContext.startTrackingSkeleton(userId);
}
void onLostUser(SimpleOpenNI curContext, int userId){ println("onLostUser - userId: " + userId);}
void onVisibleUser(SimpleOpenNI curContext, int userId){}
void keyPressed()
{
  switch(key)
  {
  case ' ':
    context.setMirror(!context.mirror());  break;
  case '0': 
    MODE=0; println("MODE: ",MODE); break;
  case '1':
    MODE=1; println("MODE: ",MODE);  break;
  case '2':
    MODE=2; println("MODE: ",MODE);  break;
  case '3':
    MODE=3; println("MODE: ",MODE);  break;
  case '4':
    MODE=4; println("MODE: ",MODE);  break;
  case '5':
    MODE=5; println("MODE: ",MODE);  break;
  case '6':
    MODE=6; vertex_num = 3; println("MODE: ",MODE);  break;
  case 's':
    stopsong(); song.play(); break;
  }
}  

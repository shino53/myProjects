int h1x, h1y, h2x, h2y, h3x, h3y, h4x, h4y, h5x, h5y;
int t1x, t1y, t2x, t2y, t3x, t3y, t4x, t4y, t5x, t5y;

void setup(){
  size(600,600);
  background(0);
  noStroke();
  h1x=200; h1y=150; h2x=350; h2y=250; h3x=460; h3y=250; h4x=350; h4y=330; h5x=250; h5y=430;
  t1x=150; t1y=200; t2x=250; t2y=240; t3x=440; t3y=350; t4x=210; t4y=330; t5x=320; t5y=430;
}

void update(){
  h1y-=1+3*sin(frameCount*0.05);
  if(random(1)>0.5) h1x+=1; else h1x-=1;
  if(h1y<100){h1y=100;} if(h1x<70){h1x=67;}
  t1y++;
  if(random(1)>0.5) t1x+=1; else t1x-=1;
  if(t1x<80){t1x=83;} if(t1y>240){t1y=240;} if(t1x>140){t1x=140;}
  
  h2y-=1+3*sin(frameCount*0.05+PI/2);
  if(random(1)>0.5) h2x+=1; else h2x-=1;
  if(h2y<100){h2y=100;} if(h2x<300){h2x=303;} if(h2x>350){h2x=345;}
  t2y++;
  if(random(1)>0.5) t2x+=1; else t2x-=1;
  if(t2x<250){t2x+=8;} if(t2x<400){t2x++;}   if(t2x>345){t2x=342;}  if(t2y>240){t2y=240;} 
  
  h3y-=1+3*sin(frameCount*0.05+PI);
  if(random(1)>0.5) h3x+=1; else h3x-=1;
  if(h3y<100){h3y=100;} if(h3x<400){h3x=403;} if(h3x>445){h3x=443;}
  t3y++;
  if(random(1)>0.5) t3x+=1; else t3x-=1;
  if(t3x<400){t3x=400;} if(t3x>445){t3x=443;} if(t3y>340){t3y=340;} 
  
  h4y-=1+3*sin(frameCount*0.05+PI);
  if(random(1)>0.5) h4x+=1; else h4x-=1;
  if(h4y<300){h4y=303;} if(h4x<100){h4x=103;} if(h4x>350){h4x=345;}
  t4y++;
  if(random(1)>0.5) t4x+=1; else t4x-=1;
  if(t4x<150){t4y++;if(t4y>440){t4y=440;} 
  }else{ t4x-=2; if(t4y>340){t4y=340;}}
   if(t4x<100){t4x=102;}
   
  h5y-=1+3*sin(frameCount*0.05);
  if(random(1)>0.5) h5x+=1; else h5x-=1;
  if(h5x<300) h5x+=2; if(h5x>400)h5x-=2;
  if(h5y<400){h5y=403;} if(h5x<100){h5x=103;} if(h5x>420){h5x=415;}
  t5y++;
  if(random(1)>0.5) t5x+=2; else t5x-=1;
  if(t5y>440){t5y=440;} if(t5x<200){t5x=202;} if(t5x>450){t5x=450;}
}

void draw(){
  background(255);
  ellipseMode(CORNER);
  drawStage();
  update();
  fill(255,160,0,150);
  ellipse(h1x,h1y,50,60);
  ellipse(h2x,h2y,50,60);
  ellipse(h3x,h3y,50,60);
  ellipse(h4x,h4y,50,60);
  ellipse(h5x,h5y,50,60);
  
  fill(70,130,180,200);
  ellipse(t1x,t1y,60,60);
  ellipse(t2x,t2y,60,60);
  ellipse(t3x,t3y,60,60);
  ellipse(t4x,t4y,60,60);
  ellipse(t5x,t5y,60,60);
  
}

void drawStage(){

  fill(255,250,205,200); //黄色
  rect(100,100,100,200);
  rect(200,100,100,100);
  
  fill(255,240,245,200); //薄ピンク
  rect(200,200,200,100);
  rect(300,100,100,100);
  
  fill(240,248,255,200); //水色
  rect(200,400,300,100);
  
  fill(230,230,250,200); //薄紫
  rect(100,300,300,100);
  rect(100,400,100,100);
  
  fill(221,160,221,200); //濃いピンク
  rect(400,100,100,300);
  
  fill(0, 100); //黒
  rect(100,298,100,5);
  rect(300,298,100,5);

}

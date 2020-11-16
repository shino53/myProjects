Wiimote wiimote;
float wiix=0, wiiy=0, wiiz=0;
float center= width/2;

void setup() 
{
  size(600,500,P3D);
  background(0);
  frameRate(1000);
  wiimote = new Wiimote(this);
}

void draw() 
{
  wiimote.update(); 

  
  //wii acceleration X
  if(wiimote.x<0){wiix=(wiimote.x+1)*300;}
  else{wiix=(300+wiimote.x*300);}
  
  //wii acceleration Y  
  if(abs(wiimote.y)<1.0){wiiy=(abs(wiimote.y-1))*0.7;}
  else if(abs(wiimote.y)>1.2){wiiy=(abs(wiimote.y-1))*1.2;}
  else{wiiy=abs(wiimote.y-1);}
  
  //wii acceleration Z
  if(wiimote.z<0){wiiz=(wiimote.z+1)*50;}
  else{wiiz=(50+wiimote.z*50);} 
  
 // println(wiimote.x, wiimote.y, wiimote.z);
 // println(wiix, wiiy, wiiz);
  int ix,iy, r=6; //for loop
  int re=200,gr=200,bl=220,al=220; //for color of circle
  noStroke();
  fill(re,gr,bl,al);//color of circle
  
  if(wiimote.b.pressed){
    fill(255,255,255);
  }
  
 
  for(iy=0; iy<50; iy+=10){
    for(ix=50; ix<550; ix+=10){
      //wii acceleration
      if(wiix-200 < ix && ix < wiix+200){
        if(abs(ix-wiix)==0 || abs(ix-wiix)<10){
          ellipse(ix,400-iy-(wiiy*90),r,r);}
        else{
          if(abs(wiix-ix) < 100){
            ellipse(ix,(400-iy-(wiiy*1000 / (int)abs(wiix-ix))),r,r);
          }
          else{
            ellipse(ix,(400-iy-(wiiy*500 / (int)abs(wiix-ix))),r,r);
          } 
        }
      }
      else{ ellipse(ix,400-iy, r, r); }
    }
    r -= 1;
    re-=10;gr-=10;bl-=10;al-=10;
  }
      
    fill(20,80);//for fade-out
    rect(0,0,width,height);//for fade-out

}

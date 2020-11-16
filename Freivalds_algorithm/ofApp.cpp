#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
    ofSetWindowTitle("Freivaldsのアルゴリズム🍎");
    ofSetVerticalSync(true);
    
    gui.setup("panel");
    gui.add(dimension.set("dimension", 2, 1, N_MAX));
    gui.add(loop.set("loop",0,0,1));
    gui.add(discorrect.set("discorrect",0,0,1));
    gui.add(error.set( "C's error", 1, 0, n*n));
    equal = true;
    started = false;
    n = dimension;
    //初期化
    for (int i = 0; i < N_MAX; i++) {
       for (int j = 0; j < N_MAX; j++) {
          A[i][j] = 0;
          B[i][j] = 0;
          Bx[i][j] = 0;
          C[i][j] = 0;
       }
        X[i][0] = ABx[i][0] = Cx[i][0] =  ABxCx[i][0] = 0;
    }
    for (int i = 0; i < n; i++) {
       for (int j = 0; j < n; j++) {
          A[i][j] = ofRandom(-5,5);
          B[i][j] = ofRandom(-5,5);
       }
        X[i][0] = (int)ofRandom(0,1.99); //fmod(ofRandom(10),2);//
    }
}

//--------------------------------------------------------------
void ofApp::update(){
    error.setMax(n*n);
    loop.setMax(loop+1);
    discorrect.setMax(loop+1);
    n = dimension;
    
    this->mesh.clear();
    
    int span = 10;
    int scale, index;
    float comp = 1;
    if(equal) comp =1;
    else comp = 0.65;
    for (int v = 0; v < 360; v += span) {
        for (int u = -170; u < 250; u += span) {
            auto noise_seed = (this->make_apple_point(u - span * 0.5, v - span * 0.5) + this->make_apple_point(u - span * 0.5, v + span * 0.5) + this->make_apple_point(u + span * 0.5, v + span * 0.5)) / 3;
            auto noise_value = ofNoise(glm::vec4(noise_seed * 0.25, ofGetFrameNum() * 0.004));
            scale = 30;
            if (noise_value > comp){
                   scale = ofMap(noise_value, 0.65, 1, 30, 60);
            }
            index = this->mesh.getNumVertices();
            
            this->mesh.addVertex(this->make_apple_point(u - span * 0.5, v - span * 0.5) * scale);
            this->mesh.addVertex(this->make_apple_point(u - span * 0.5, v + span * 0.5) * scale);
            this->mesh.addVertex(this->make_apple_point(u + span * 0.5, v + span * 0.5) * scale);
            this->mesh.addIndex(index); this->mesh.addIndex(index + 1); this->mesh.addIndex(index + 2);
            noise_seed = (this->make_apple_point(u - span * 0.5, v - span * 0.5) + this->make_apple_point(u + span * 0.5, v - span * 0.5) + this->make_apple_point(u + span * 0.5, v + span * 0.5)) / 3;
            noise_value = ofNoise(glm::vec4(noise_seed * 0.25, ofGetFrameNum() * 0.004));
            scale = 30;
            if (noise_value > comp){//abs(sin(ofGetFrameNum()*0.005+PI/2))){//0.65) {
                scale = ofMap(noise_value, 0.65, 1, 30, 60);
            }
            index = this->mesh.getNumVertices();
            this->mesh.addVertex(this->make_apple_point(u - span * 0.5, v - span * 0.5) * scale);
            this->mesh.addVertex(this->make_apple_point(u + span * 0.5, v - span * 0.5) * scale);
            this->mesh.addVertex(this->make_apple_point(u + span * 0.5, v + span * 0.5) * scale);
    
            this->mesh.addIndex(index); this->mesh.addIndex(index + 1); this->mesh.addIndex(index + 2);
           }
       }
}

//--------------------------------------------------------------
void ofApp::draw(){
    gui.draw();
    
    ofDrawBitmapString("X", 10, 150);
    ofDrawBitmapString("A", 10, 180);
    ofDrawBitmapString("B", 10, 200+10*n);
    ofDrawBitmapString("C", 10, 220+10*2*n);
    ofDrawBitmapString("ABx", 10, 250+10*3*n);
    ofDrawBitmapString("Cx", 10, 260+10*4*n);
    if(equal) ofDrawBitmapString("YES", 20, 270+10*5*n);
    else ofDrawBitmapString("No", 20, 270+10*5*n);
    
    for (int i = 0; i < n; i++) {
       ofDrawBitmapString(ofToString(X[i][0],1), 100 + 40 * i, 150);
       ofDrawBitmapString(ofToString(ABx[i][0],1), 100 + 40 * i, 250+10*3*n);
       ofDrawBitmapString(ofToString(Cx[i][0],1), 100 + 40 * i, 260+10*4*n);
       for (int j = 0; j < n; j++) {
          ofDrawBitmapString(ofToString(A[i][j],1), 100+40*i, 180+10*j);
          ofDrawBitmapString(ofToString(B[i][j],1), 100+40*i, 200+10*n+10*j);
          ofDrawBitmapString(ofToString(C[i][j],1), 100+40*i, 220+10*2*n+10*j);
       }
    }
    
    
    ofTranslate(ofGetWidth()/2,ofGetHeight()/2);
    ofRotateX(-PI/2);
    ofRotateX(ofGetFrameNum() * 0.1);
    ofRotateZ(ofGetFrameNum() * 0.5);
    
    ofSetColor(39);
    this->mesh.drawFaces();
    
    ofSetColor(239);
    if(equal) ofSetColor(255,0,0);
    this->mesh.drawWireframe();
    
}

//--------------------------------------------------------------
void ofApp::keyPressed(int key){

}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){

}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){

}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){
    started = true;
    loop++;
    //A,B,X代入
    for (int i = 0; i < n; i++) {
       for (int j = 0; j < n; j++) {
          A[i][j] = ofRandom(-5,5);
          B[i][j] = ofRandom(-5,5);
       }
        X[i][0] = (int)ofRandom(0,1.99);
    }
    //Bx
    for(int i=0; i < n; i++){
        for(int j = 0; j < 1; j++){
            Bx[i][j] = 0;
            for(int k = 0; k < n; k++){
                Bx[i][j] += A[i][k]*X[k][j];
            }
        }
    }

    //A(Bx)
    for(int i=0; i<n; i++){
        
        for(int j=0; j<1; j++){
            ABx[i][j] = 0;
            for(int k=0; k<n; k++){
               ABx[i][j] += A[i][k]*Bx[k][j];
            }
        }
    }
    
    //C代入
    for (int i = 0; i < n; i++) {
       for (int j = 0; j < n; j++) {
           C[i][j] = 0;
           for(int k = 0; k < n; k++){
               C[i][j] += A[i][k]*B[k][j];
           }
       }
    }
    for(int e = error; e>0; e--){ //--changed
        C[(int)ofRandom(0,n)][(int)ofRandom(0,n)] += ofRandom(-10,10);
    }

    //Cx
    for(int i=0; i<n; i++){
        for(int j=0; j<1; j++){
            Cx[i][j] = 0;
            for(int k=0; k<n; k++){
                Cx[i][j] += C[i][k]*X[k][j];

            }
        }
    }
    
    //一致しているかの判定
    for (int i = 0; i < n; i++) {
       ABxCx[i][0] = ABx[i][0] - Cx[i][0];
    }
    equal = true;
    for (int i = 0; i < n; i++) {
       if (ABxCx[i][0] == 0)
           continue;
       else
           equal = false;
    }
    
    
    
    if(error!=0 && started) discorrect += equal;
}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}

//--------------------------------------------------------------
glm::vec3 ofApp::make_apple_point(float u, float v) {
    u *= DEG_TO_RAD;
    v *= DEG_TO_RAD;
 
    float x = (4 + 3.8 * cos(u)) * cos(v);
    float y = (4 + 3.8 * cos(u)) * sin(v);
    float z = -5 * log10(1 - 0.315 * u) + 5 * sin(u) + 2 * cos(u);
 
    return glm::vec3(x, y, z);
}

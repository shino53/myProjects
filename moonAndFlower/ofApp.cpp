#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    //ofSetFrameRate(100);
    fs.push_back(FireBall(ofGetWidth()/2, ofGetHeight()/2+200));
    ofBackground(0);
    ofEnableAlphaBlending();
    ofSetRectMode(OF_RECTMODE_CENTER);
    Particle::setup();
    ofEnableBlendMode(OF_BLENDMODE_ADD);
    
    this->mesh.setMode(ofPrimitiveMode::OF_PRIMITIVE_LINES);
}

//--------------------------------------------------------------
void ofApp::update(){
    for (vector<FireBall>::iterator it=fs.begin(); it!=fs.end(); ++it) {
    it->update();
    }
    
    //ofSeedRandom(39);
    
    this->mesh.clear();
    
    for (int i = 0; i < 4; i++) {
    
        auto noise_seed = glm::vec3(ofRandom(100), ofRandom(100), ofRandom(100));
        for (int deg = 0; deg < 360; deg += 5) {

            auto angle_x = ofMap(ofNoise(noise_seed.x, cos(deg * DEG_TO_RAD), ofGetFrameNum() * 0.003), 0, 1, 0, PI);
            auto angle_y = ofMap(ofNoise(noise_seed.y, sin(deg * DEG_TO_RAD), ofGetFrameNum() * 0.003), 0, 1, 0, PI);
            auto angle_z = ofMap(ofNoise(noise_seed.z, ofGetFrameNum() * 0.0035), 0, 1, 0, PI);
    
            auto rotation_x = glm::rotate(glm::mat4(), angle_x, glm::vec3(1, 0, 0));
            auto rotation_y = glm::rotate(glm::mat4(), angle_y, glm::vec3(0, 1, 0));
            auto rotation_z = glm::rotate(glm::mat4(), angle_z, glm::vec3(0, 0, 1));
    
            auto location = glm::vec3(80 * cos(deg * DEG_TO_RAD), 80 * sin(deg * DEG_TO_RAD), 0);
            location = glm::vec4(location, 0) * rotation_z * rotation_y * rotation_x;
    
            this->mesh.addVertex(location);
        }
    }
    
    for (int i = 0; i < this->mesh.getNumVertices(); i++) {
        for (int k = 0; k < this->mesh.getNumVertices(); k++) {
            if (i == k) { continue; }
            if (glm::distance(this->mesh.getVertex(i), this->mesh.getVertex(k)) < 40) {
                this->mesh.addIndex(i); this->mesh.addIndex(k);
            }
        }
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    //this->cam.begin();
    for (vector<FireBall>::iterator it=fs.begin(); it!=fs.end(); ++it) {it->draw();}
    //ofRotateY(ofGetFrameNum());
    
    ofSetColor(255,250,205, 30);
    ofTranslate(ofGetWidth()/2, ofGetHeight()/2-200);
    ofRotateZDeg(ofGetFrameNum());
    ofRotateYDeg(ofGetFrameNum());
    ofRotateXDeg(ofGetFrameNum());
    this->mesh.drawWireframe();
    //for (auto& vertex : this->mesh.getVertices()) {ofDrawSphere(vertex, 2);}
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

#include "ofApp.h"

//--
using namespace cv;
//--

//--------------------------------------------------------------
void ofApp::setup(){
    #ifdef _USE_LIVE_VIDEO
        vidGrabber.initGrabber(640, 480);
        ofSetLogLevel(OF_LOG_VERBOSE);
        vidGrabber.listDevices();
        vidGrabber.setDeviceID(0);
    #else
        vidPlayer.load("prfmsecret2.mp4");
        vidPlayer.play();
        vidPlayer.setLoopState(OF_LOOP_NORMAL);
    #endif

    ofSetFrameRate(30);
    colorImg.allocate(320,240);
    grayImage.allocate(320,240);
    grayBg.allocate(320,240);
    grayDiff.allocate(320,240);

    bLearnBakground = true;
    threshold = 80; //threshold = 60;
}

//--------------------------------------------------------------
void ofApp::update(){
    ofBackground(100,100,100);

    bool bNewFrame = false;

    #ifdef _USE_LIVE_VIDEO
       vidGrabber.update();
       bNewFrame = vidGrabber.isFrameNew();
    #else
        vidPlayer.update();
        bNewFrame = vidPlayer.isFrameNew();
    #endif

    if (bNewFrame){
        #ifdef _USE_LIVE_VIDEO
            colorImg.setFromPixels(vidGrabber.getPixels());
        #else
            colorImg.setFromPixels(vidPlayer.getPixels());
        #endif
        
        colorImg.resize(320,240);
        grayImage = colorImg;
        
        if (bLearnBakground == true){
            grayBg = grayImage;
            bLearnBakground = false;
        }
        grayDiff.absDiff(grayBg, grayImage);
        grayDiff.threshold(threshold);
        contourFinder.findContours(grayDiff, 20, (340*240)/3, 10, true);
        // 動的配列をクリアする
        edgeLines.clear();
        for(int i = 0; i< contourFinder.nBlobs; i++){
            ofPolyline line;
            // ２周目for文でそれぞれの輪郭の点にアクセスし、点を結んで線にする。
            for(int j =0; j<contourFinder.blobs[i].pts.size(); j++){
                // 点を線にする。
                line.addVertex(contourFinder.blobs[i].pts[j]);
            }
            // 作成した線を格納
            edgeLines.push_back(line);
        }
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofEnableBlendMode(OF_BLENDMODE_MULTIPLY);
    ofSetHexColor(0xffffff);
    colorImg.draw(20,20);
    grayImage.draw(360,20);
    grayBg.draw(20,280);
    grayDiff.draw(360,280);
    ofFill();
    ofSetHexColor(0x333333);
    ofDrawRectangle(360,540,320,240);

    for (int i = 0; i < contourFinder.nBlobs; i++){
        // 輪郭線の描画
        for(int cnt = 0; cnt< edgeLines.size(); cnt++){
            ofPushMatrix();
            ofTranslate(360, 540);
            ofSetLineWidth(5);
            ofSetColor(250, 230, 250, 180);
            edgeLines[cnt].draw();
            ofPopMatrix();
        }
    }

    // finally, a report:
    ofSetHexColor(0xffffff);
    stringstream reportStr;
    reportStr << "bg subtraction and blob detection" << endl
              << "press ' ' to capture bg" << endl
              << "threshold " << threshold << " (press: +/-)" << endl
              << "num blobs found " << contourFinder.nBlobs << ", fps: " << ofGetFrameRate();
    ofDrawBitmapString(reportStr.str(), 20, 600);
    

}
//--------------------------------------------------------------
void ofApp::keyPressed(int key){

    switch (key){
        case ' ':
            bLearnBakground = true;
            break;
        case '+':
            threshold ++;
            if (threshold > 255) threshold = 255;
            break;
        case '-':
            threshold --;
            if (threshold < 0) threshold = 0;
            break;
    }
}

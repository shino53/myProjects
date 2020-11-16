#pragma once

#include "ofMain.h"
#include "ofxGui.h"
#include <iostream>
#include <stdio.h>
#include <stdlib.h>
using namespace std;

#define N_MAX       8

class ofApp : public ofBaseApp{
    
	public:
		void setup();
		void update();
		void draw();

		void keyPressed(int key);
		void keyReleased(int key);
		void mouseMoved(int x, int y );
		void mouseDragged(int x, int y, int button);
		void mousePressed(int x, int y, int button);
		void mouseReleased(int x, int y, int button);
		void mouseEntered(int x, int y);
		void mouseExited(int x, int y);
		void windowResized(int w, int h);
		void dragEvent(ofDragInfo dragInfo);
		void gotMessage(ofMessage msg);

        
        ofxPanel gui;
        ofParameter<int> dimension; //次元数
        ofParameter<int> loop; //何回やったか
        ofParameter<int> error; //ミス何個作るか
        ofParameter<int> discorrect; //何回判定間違えたか
    
        int n;
        int loopcnt;
    
        double A[N_MAX][N_MAX];
        double B[N_MAX][N_MAX];
        double C[N_MAX][N_MAX];
        //double Z[N_MAX][N_MAX];
        double X[N_MAX][1];
    
        double Bx[N_MAX][N_MAX];
        double ABx[N_MAX][1];
        double ABxCx[N_MAX][1];
        double Cx[N_MAX][1];
        bool equal;
        bool started;
        
        glm::vec3 make_apple_point(float u, float v);
        ofMesh mesh;
        //ofEasyCam cam;
		
};

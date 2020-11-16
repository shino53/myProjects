#include "FireBall.h"
ofImage Particle::img;
Particle::Particle(ofPoint _p, float _size){
    size = _size;
    p = _p;
    v = ofPoint(ofRandom(-130, 130), ofRandom(-50,50));
    v = 0.1*size*ofRandom(1)*v.normalize(); //初期速度
    c = _p;
}

void Particle::setup(){
    img.loadImage("particle2.png");
}

void Particle::update(){
    p += v;
    ofPoint d = p-c;
    v.x += 0.04*(ofRandom(-2, 2)-.3*d.x)*size; // だんだんと真ん中に寄るように
    v.y += -0.005*size*ofRandom(1.5); // 上に昇るように
    lt-=0.05; // 残り生存時間を減らす
};

void Particle::draw(){
    
    img.draw(p,5*size, 5*size);
};

bool Particle::isDead(){
    return (lt <= 0);
}

FireBall::FireBall(float x, float y){
    pos = ofPoint(x,y);
    size = 10+ofRandom(-5,5); // ここで大きさを指定してやる
}

void FireBall::update(){
    // パーティクルを追加
    for(int i=0; i<3; ++i)    ps.push_back(Particle(pos, size));
    for (vector<Particle>::iterator it=ps.begin(); it != ps.end(); ++it) {
        it->update();
    }
    for (vector<Particle>::iterator it=ps.begin(); it != ps.end(); ++it) {
        if(it->isDead()){
            ps.erase(it);
            --it;
        }
    }
};

void FireBall::draw(){
    for (vector<Particle>::iterator it=ps.begin(); it != ps.end(); ++it) {
        it->draw();
    }
};

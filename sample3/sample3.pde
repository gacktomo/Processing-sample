import codeanticode.syphon.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.*;
int BUFSIZE = 512;
Minim minim;
// AudioPlayer player; //サウンドプレイヤー
AudioInput player;
SyphonServer server;
LowPassSP lpf;
FFT fft;

void settings() {
  size(720, 480, P3D);
  PJOGL.profile=1;
  smooth(8);
}

void setup() {
  colorMode(HSB, 360, 100, 100, 100);
  // blendMode(ADD);
  noStroke();
  minim = new Minim(this);
  server = new SyphonServer(this, "processing_sample");
  // サウンドファイル再生
  // player = minim.loadFile("../white_cube.mp3");
  // player.loop();
  player = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(player.bufferSize(), player.sampleRate());
  fft.window(FFT.HAMMING);
  lpf = new LowPassSP(500, player.sampleRate());
  player.addEffect(lpf); 
}

void draw() {
  background(0);

  fft.forward(player.left);
  for (int i = 0; i < fft.specSize()/8; i++) {
    if( i==2 && fft.getBand(i)>=25 ){
      background(255);
    }
    float h= map(fft.getBand(i), 0, 10, 0, 100);
    float x = map(i, 0, fft.specSize()/8, width/2, 10);
    float ellipseSize = map(fft.getBand(i), 0, 50, 0, height*0.8);
    // float ellipseSize = map(fft.getBand(i), 0, BUFSIZE/16, 0, width);
    fill(h, 60, 100, 30);
    ellipse(x, height/2, ellipseSize, ellipseSize);

    if(mouseX == round(x)){
      text("band: "+i+"Hz, level: "+fft.getBand(i), width/2, 30);
    }
  }

  fft.forward(player.right);
  for (int i = 0; i < fft.specSize()/8; i++) {
    float h= map(fft.getBand(i), 0, 10, 0, 100);
    float x = map(i, 0, fft.specSize()/8, width/2, width-10);
    float ellipseSize = map(fft.getBand(i), 0, 50, 0, height*0.8);
    fill(h, 60, 100, 30);
    ellipse(x, height/2, ellipseSize, ellipseSize);
  }
  server.sendScreen();
}
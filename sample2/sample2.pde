import ddf.minim.analysis.*;
import ddf.minim.*;
int BUFSIZE = 512;
Minim minim;
AudioPlayer player; //サウンドプレイヤー
FFT fft;

void setup() {
size(1024, 400, P3D);
colorMode(HSB, 360, 100, 100, 100);
noStroke();

//Minim初期化
minim = new Minim(this);

// サウンドファイル再生
player = minim.loadFile("../white_cube.mp3");
player.loop();
// FFT
fft = new FFT(player.bufferSize(), BUFSIZE);
//分析窓は、ハミング窓で
fft.window(FFT.HAMMING);
}

void draw() {
  background(0);

  fft.forward(player.left);
  for (int i = 0; i < fft.specSize(); i++) {
    float h = map(i, 0, fft.specSize(), 0, 180);
    float a = map(fft.getBand(i), 0, BUFSIZE/16, 0, 255);
    float x = map(i, 0, fft.specSize(), width/2, 0);
    float w = width / float(fft.specSize()) / 2;
    fill(h, 80, 80, a);
    rect(x, 0, w, height);
  }

  fft.forward(player.right);
  for (int i = 0; i < fft.specSize(); i++) {
    float h = map(i, 0, fft.specSize(), 0, 180);
    float a = map(fft.getBand(i), 0, BUFSIZE/16, 0, 255);
    float x = map(i, 0, fft.specSize(), width/2, width);
    float w = width / float(fft.specSize()) / 2;
    fill(h, 80, 80, a);
    rect(x, 0, w, height);
  }
}

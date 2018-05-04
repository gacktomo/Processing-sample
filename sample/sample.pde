import ddf.minim.analysis.*;
import ddf.minim.*;
Minim minim;
AudioPlayer player; //サウンドプレイヤー
FFT fft;

void setup() {
  size(1024, 400, P3D);
  colorMode(HSB, 360, 100, 100, 100);

  //Minim初期化
  minim = new Minim(this);

  // サウンドファイル再生
  player = minim.loadFile("../white_cube.mp3");
  player.loop();
  // FFT
  fft = new FFT(player.bufferSize(), 512);
  //分析窓は、ハミング窓で
  fft.window(FFT.HAMMING);
}

void draw() {
  background(0);

  //FFT変換実行
  fft.forward(player.mix);

  //グラフ生成
  for (int i = 0; i < fft.specSize (); i++) {
    float h = map(i, 0, fft.specSize(), 0, 180);
    stroke(h, 100, 100);
    strokeWeight(2);
    float x = map(i, 0, fft.specSize(), 0, width);
    line(x, height, x, height - fft.getBand(i) * 8);
  }
}
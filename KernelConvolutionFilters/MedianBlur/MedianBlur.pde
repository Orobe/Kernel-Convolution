PImage inputImg;
PImage outputImg;

int W = 1920, H = 1080;
int newW, newH;
float[][] kernel = { 
  { 1, 1, 1, 1, 1 },
  { 1, 1, 1, 1, 1 },
  { 1, 1, 1, 1, 1 },
  { 1, 1, 1, 1, 1 },
  { 1, 1, 1, 1, 1 }
};

float kernelVal = 0;

void setup() {
  size(1920, 1080);
  inputImg = loadImage("input/landscape.jpg");
  newW = W - kernel[0].length + 1;
  newH = H - kernel[0].length + 1;
  outputImg = createImage(W, H, RGB);
  for(int i = 0; i < kernel[0].length; i++)
    for(int j = 0; j < kernel[0].length; j++)
      kernelVal += kernel[i][j];
}

void draw() {
  background(0);
  inputImg.loadPixels();
  outputImg.loadPixels();
  for (int j = 0; j < H; j++) {
    for (int i = 0; i < W; i++) {
      float sumR = 0;
      float sumG = 0;
      float sumB = 0;
      for(int x = 0; x < kernel[0].length; x++){
         for(int y = 0; y < kernel[0].length; y++){
           int xIndex = i - x - 1;
           if(xIndex < 0) xIndex = 0;
           else if(xIndex >= W) xIndex = W - 1;
           int yIndex = j - y + 1;
           if(yIndex < 0) yIndex = 0;
           else if(yIndex >= H) yIndex = H - 1;
           int tileIndex = xIndex + yIndex * W;
           sumR += kernel[x][y] * red(inputImg.pixels[tileIndex]);
           sumG += kernel[x][y] * green(inputImg.pixels[tileIndex]);
           sumB += kernel[x][y] * blue(inputImg.pixels[tileIndex]);
           //println(red(pixels[newI + newJ * newW]));
         }     
      }
      
      color c = color(sumR / kernelVal, sumG / kernelVal, sumB / kernelVal);
      //color c = color(0, 255, 0);
      outputImg.pixels[i + j * W] = c;




    }
  }
  image(outputImg, 0, 0);
  saveFrame("output/median_blur.png");
  //image(img, 0, 0);
  //image(smaller, 0, 0);
  noLoop();
}

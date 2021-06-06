PImage inputImg;
PImage outputImg;

int W = 256, H = 256;
float[][] kernel;
int kernelRadius = 9;
int kernelSize;

float kernelVal = 0;

void setup() {
  size(256, 256);
  inputImg = loadImage("input/testing.png");
  W = inputImg.width;
  H = inputImg.height;
  outputImg = createImage(W, H, RGB);    
  
  //Generate kernel
  kernelSize = kernelRadius * 2 + 1;
  kernel = new float[kernelSize][kernelSize];
  
  //Generate kernel values (all values = 1)
  kernelVal = kernelSize * kernelSize;
  for(int i = 0; i < kernelSize; i++)
    for(int j = 0; j < kernelSize; j++)
      kernel[i][j] = 1;
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
      
      for(int x = 0; x < kernelSize; x++){
         for(int y = 0; y < kernelSize; y++){
           int xIndex = i + x - kernelRadius;
           if(xIndex < 0) xIndex = 0;
           else if(xIndex >= W) xIndex = W - 1;
           
           int yIndex = j + y - kernelRadius;
           if(yIndex < 0) yIndex = 0;
           else if(yIndex >= H) yIndex = H - 1;
           int tileIndex = xIndex + yIndex * W;
           
           sumR += kernel[x][y] * red(inputImg.pixels[tileIndex]);
           sumG += kernel[x][y] * green(inputImg.pixels[tileIndex]);
           sumB += kernel[x][y] * blue(inputImg.pixels[tileIndex]);
         }     
      }
      
      color c = color(sumR / kernelVal, sumG / kernelVal, sumB / kernelVal);
      outputImg.pixels[i + j * W] = c;




    }
  }
  image(outputImg, 0, 0);
  saveFrame("output/median_blur.png");
  noLoop();
}

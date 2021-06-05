PImage inputImg;
PImage outputImg;

int W = 1920, H = 1080;
float[][] kernel;
int kernelRadius = 9;
int kernelSize;

float kernelVal = 0;

void setup() {
  size(1920, 1080);
  inputImg = loadImage("input/landscape.jpg");
  outputImg = createImage(W, H, RGB);    
  
  //Generate kernel
  kernelSize = kernelRadius * 2 + 1;
  kernel = new float[kernelSize][kernelSize];
  
  //Generate kernel values (all values = 1)
  kernelVal = kernel[0].length * kernel[0].length;
  for(int i = 0; i < kernel[0].length; i++)
    for(int j = 0; j < kernel[0].length; j++)
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

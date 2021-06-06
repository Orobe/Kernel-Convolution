PImage inputImg;
PImage outputImg;

int W, H;
float[][] kernel;
int kernelRadius = 1;
int kernelSize;

float kernelVal = 0;

void setup() {
  size(1920, 1080);
  inputImg = loadImage("input/landscape.jpg");
  W = inputImg.width;
  H = inputImg.height;
  outputImg = createImage(W, H, RGB);
  
  //Generate kernel
  kernelSize = kernelRadius * 2 + 1;
  kernel = new float[kernelSize][kernelSize];
  float sum = 0;
  
  //Generate kernel values (following a normal distribution)
  float sigma = max(kernelRadius / 2, 1);
  for(int i = -kernelRadius; i < kernelRadius + 1; i++){
    for(int j = -kernelRadius; j < kernelRadius + 1; j++){
      float expNumerator = -(i * i + j * j);
      float expDenominator = 2 * sigma * sigma;
      float eExp = exp(expNumerator / expDenominator);
      
      
      float kernelVal = eExp / (2 * PI * sigma * sigma);
      kernel[i + kernelRadius][j + kernelRadius] = kernelVal;
      sum += kernelVal;
    
    }   
  }
  println(kernelSize);
  //Normalize kernel (sum of all values = 1)
  for(int i = 0; i < kernelSize; i++)
    for(int j = 0; j < kernelSize; j++){
      println(kernel[i][j]);
      kernel[i][j] /= sum;

    }
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
      color c = color(sumR, sumG, sumB);
      outputImg.pixels[i + j * W] = c;

    }
  }
  image(outputImg, 0, 0);
  saveFrame("output/gaussian_blur.png");
  noLoop();
}

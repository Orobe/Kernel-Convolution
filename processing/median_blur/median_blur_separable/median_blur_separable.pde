PImage inputImg;
PImage outputImg;

int w, h;
float[] kernel;
float[][] horizontalPass;
int kernelRadius = 9;
int kernelSize;

float kernelVal = 0;

void setup() {
  size(1920, 1080);
  inputImg = loadImage("input/landscape.jpg");
  w = inputImg.width;
  h = inputImg.height;
  outputImg = createImage(w, h, RGB);    
  
  //Generate kernel
  kernelSize = kernelRadius * 2 + 1;
  kernel = new float[kernelSize];
  horizontalPass = new float[w * h][4];
  
  //Generate kernel values (all values = 1)
  kernelVal = kernelSize;
  for(int i = 0; i < kernelSize; i++)
    kernel[i] = 1;
}

void draw() {
  background(255);
  inputImg.loadPixels();
  outputImg.loadPixels();
  
  
  //Horizontal pass
  for (int j = 0; j < h; j++) {
    for (int i = 0; i < w; i++) {
      float sumR = 0;
      float sumG = 0;
      float sumB = 0;
      float sumA = 0;
      
      for(int x = 0; x < kernelSize; x++){
         int xIndex = i + x - kernelRadius;
         if(xIndex < 0) xIndex = 0;
         else if(xIndex >= w) xIndex = w - 1;
         int tileIndex = xIndex + j * w;
         
         sumR += kernel[x] * red(inputImg.pixels[tileIndex]);
         sumG += kernel[x] * green(inputImg.pixels[tileIndex]);
         sumB += kernel[x] * blue(inputImg.pixels[tileIndex]);
         sumA += kernel[x] * alpha(inputImg.pixels[tileIndex]);
       }     
      
        horizontalPass[i + j * w][0] = sumR / kernelVal;
        horizontalPass[i + j * w][1] = sumG / kernelVal;
        horizontalPass[i + j * w][2] = sumB / kernelVal;
        horizontalPass[i + j * w][3] = sumA / kernelVal;
      }
    }
    
    //Vertical pass using values calculated in the horizontal pass
    for (int j = 0; j < h; j++) {
      for (int i = 0; i < w; i++) {
        float sumR = 0;
        float sumG = 0;
        float sumB = 0;
        float sumA = 0;
        
        for(int y = 0; y < kernelSize; y++){
           int yIndex = j + y - kernelRadius;
           if(yIndex < 0) yIndex = 0;
           else if(yIndex >= h) yIndex = h - 1;
           int tileIndex = i + yIndex * w;
           
           sumR += kernel[y] * horizontalPass[tileIndex][0];
           sumG += kernel[y] * horizontalPass[tileIndex][1];
           sumB += kernel[y] * horizontalPass[tileIndex][2];
           sumA += kernel[y] * horizontalPass[tileIndex][3];
         }     
             
        color c = color(sumR / kernelVal, sumG / kernelVal, sumB / kernelVal, sumA / kernelVal);
        outputImg.pixels[i + j * w] = c;

      }
    }
  image(outputImg, 0, 0);
  saveFrame("output/median_blur.png");
  noLoop();
}

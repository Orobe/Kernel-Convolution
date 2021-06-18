PImage inputImg;
PImage outputImg;

int w = 1920, h = 1080;
float[][] kernelX = { { -1, 0, 1 },
                      { -2, 0, 2 },
                      { -1, 0, 1 } };
float[][] kernelY = { { -1, -2, -1 },
                      { 0, 0, 0 },
                      { 1, 2, 1 } };
float[][] values;

void setup() {
  size(1920, 1080);
  inputImg = loadImage("input/luski.png");
  inputImg.filter(GRAY);
  w = inputImg.width;
  h = inputImg.height;
  values = new float[w][h];
  outputImg = createImage(w, h, RGB);   
}

void draw() {
  background(0);
  inputImg.loadPixels();
  outputImg.loadPixels();
  
  for(int i = 0; i < w; i++) {
   for(int j = 0; j < h; j++) {
      float totalX = 0;
      float totalY = 0;
      
      for(int x = 0; x < kernelX.length; x++){
         for(int y = 0; y < kernelY.length; y++){
           int xIndex = i + x - kernelX.length;
           if(xIndex < 0) xIndex = 0;
           else if(xIndex >= w) xIndex = w - 1;
           
           int yIndex = j + y - kernelY.length;
           if(yIndex < 0) yIndex = 0;
           else if(yIndex >= h) yIndex = h - 1;
           int tileIndex = xIndex + yIndex * w;
           
           totalX += kernelX[x][y] * red(inputImg.pixels[tileIndex]);
           totalY += kernelY[x][y] * red(inputImg.pixels[tileIndex]);
         }     
      }
      values[i][j] = sqrt(pow(totalX, 2) + pow(totalY, 2));
    }
  }
  
  float[] mins = new float[w];
  float[] maxs = new float[w];
  
  for (int i = 0; i < w; i++) {
    mins[i] = min(values[i]);
    maxs[i] = max(values[i]);
  }
  
  float min = min(mins);
  float max = max(maxs);
  
  for(int i = 0; i < w; i++) {
   for(int j = 0; j < h; j++) {
     float c = map(values[i][j], min, max, 0, 255 );
      outputImg.pixels[i + j * w] = color(c, c, c);
    }
  }
  
  image(outputImg, 0, 0);
  saveFrame("output/median_blur.png");
  noLoop();
}

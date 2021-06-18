PImage inputImg;
PImage outputImg;

int w = 1920, h = 1080;
float[] kernelX_v = { 1, 2, 1 };
float[] kernelX_h = { 1, 0, -1 };
float[] kernelY_v = { 1, 0, -1 };
float[] kernelY_h = { 1, 2, 1 };
float[][] values;
float[][] values_x;
float[][] values_y;

void setup() {
  size(1920, 1080);
  inputImg = loadImage("input/43027.jpg");
  inputImg.filter(GRAY);
  inputImg.filter(BLUR, 3);
  w = inputImg.width;
  h = inputImg.height;
  values = new float[w][h];
  values_x = new float[w][h];
  values_y = new float[w][h];
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
      
      for(int x = 0; x < kernelX_h.length; x++){
 
         int xIndex = i + x - kernelX_h.length;
         if(xIndex < 0) xIndex = 0;
         else if(xIndex >= w) xIndex = w - 1;
         int tileIndex = xIndex + j * w;
         
         totalX += kernelX_h[x] * red(inputImg.pixels[tileIndex]);
         totalY += kernelY_h[x] * red(inputImg.pixels[tileIndex]);
           
      }
      values_x[i][j] = totalX;
      values_y[i][j] = totalY;
    }
  }

  for(int i = 0; i < w; i++) {
   for(int j = 0; j < h; j++) {
      float totalX = 0;
      float totalY = 0;
      
      for(int y = 0; y < kernelX_v.length; y++){
 
         int yIndex = j + y - kernelX_v.length;
         if(yIndex < 0) yIndex = 0;
         else if(yIndex >= h) yIndex = h - 1;
         totalX += kernelX_v[y] * values_x[i][yIndex];
         totalY += kernelY_v[y] * values_y[i][yIndex];
         
           
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

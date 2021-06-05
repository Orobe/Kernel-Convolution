let canvas;
let inputImg;
let outputImg;

function setup() {
    let input = createFileInput(loadImg, false).elt;
    input.classList.add('form-control');
    input.setAttribute('accept', '.jpg,.png');
    input.remove();
    document.getElementById('input-form').appendChild(input);
    canvas = createCanvas(400, 400);
    pixelDensity(1);
    document.getElementById('radius-slider').value = 1;
}
let x = 0;
function draw() {
    background(255);
    noStroke();
    if (inputImg != null) {
        image(inputImg, 0, 0, width, height);
    }
    noLoop();
}

let fileName;
function loadImg(file) {
    if (file.type === 'image') {
        fileName = file.name;
        inputImg = loadImage(file.data, '', () => {
            //calculateResizeCanvas(inputImg.width, inputImg.height);
        });
        setTimeout(redraw, 0);
    }
}

function calculateResizeCanvas(width, height) {

}

let kernelRadius = 1;
let kernelSize;
let kernel = [];
let kernelVal = 0;

function generateKernel() {
    kernelRadius = document.getElementById('radius-slider').value;
    kernelSize = kernelRadius * 2 + 1;
    kernel = new Array(kernelSize).fill(new Array(kernelSize).fill(1));
    kernelVal = kernelSize * kernelSize;
}

function filterImage() {
    let w = inputImg.width;
    let h = inputImg.height;
    outputImg = createImage(w, h);
    inputImg.loadPixels();
    outputImg.loadPixels();

    for (let j = 0; j < h; j++) {
        for (let i = 0; i < w; i++) {
            let sumR = 0;
            let sumG = 0;
            let sumB = 0;
            let sumA = 0;

            for (let x = 0; x < kernelSize; x++) {
                for (let y = 0; y < kernelSize; y++) {
                    let xIndex = i - x - 1;
                    if (xIndex < 0) xIndex = 0;
                    else if (xIndex >= w) xIndex = w - 1;

                    let yIndex = j - y + 1;
                    if (yIndex < 0) yIndex = 0;
                    else if (yIndex >= h) yIndex = h - 1;
                    let tileIndex = (xIndex + yIndex * w) * 4;
                    sumR += kernel[x][y] * red(inputImg.pixels[tileIndex]);
                    sumG += kernel[x][y] * green(inputImg.pixels[tileIndex + 1]);
                    sumB += kernel[x][y] * blue(inputImg.pixels[tileIndex + 2]);
                    sumA += kernel[x][y] * alpha(inputImg.pixels[tileIndex + 3])
                }
            }

            let index = (i + j * w) * 4;
            outputImg.pixels[index] = sumR / kernelVal;
            outputImg.pixels[index + 1] = sumG / kernelVal;
            outputImg.pixels[index + 2] = sumB / kernelVal;
            outputImg.pixels[index + 3] = sumA / kernelVal;
        }
    }
    print(outputImg.pixels);
    outputImg.updatePixels();
    image(outputImg, 0, 0, width, height);
    alert('finished');
}

function startFilter() {
    if (!inputImg) {
        alert('Please upload an image before pressing the start button.');
        return;
    }
    generateKernel();
    filterImage();
}

function downloadOutput() {
    if (!outputImg) {
        alert('Download is not ready yet!');
        return;
    }
    outputImg.save('median-blur', 'png');
}

function updateRadiusLabel() {
    document.getElementById('radius-value').innerHTML = document.getElementById('radius-slider').value;
}
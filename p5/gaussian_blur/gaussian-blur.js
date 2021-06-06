let canvas;
let inputImg;
let outputImg;

function setup() {
    let input = createFileInput(loadImg, false).elt;
    input.classList.add('form-control');
    input.id = 'file-input';
    input.setAttribute('accept', '.jpg,.png');
    input.remove();
    document.getElementById('input-form').appendChild(input);
    canvas = createCanvas(300, 300);
    calculateResizeCanvas();
    pixelDensity(1);
    document.getElementById('radius-slider').value = 1;
    document.getElementById('notification-close').addEventListener('click', () => {
        document.getElementById('notification').classList.remove('notification-show');
    })
}

let showInput = true;
function draw() {
    background(255);
    noStroke();
    if (inputImg && showInput) image(inputImg, 0, 0, width, height);
    else if (outputImg) image(outputImg, 0, 0, width, height);
    noLoop();
}

let fileName;
function loadImg(file) {
    if (file.type === 'image') {
        fileName = file.name;
        inputImg = loadImage(file.data, () => {
            document.getElementById('btn-start').disabled = false;
            showInput = true;
            calculateResizeCanvas();
        }, () => { alert('There was an error when loading the image. Please try again.'); });
    }
}

function calculateResizeCanvas() {
    let parent = canvas.elt.parentElement;
    let maxWidth = parent.offsetWidth;
    let maxHeight = parent.offsetHeight;
    
    if (inputImg){
        let imgRatio = inputImg.width / inputImg.height;
        if (maxWidth >= inputImg.width && maxHeight >= inputImg.height) resizeCanvas(inputImg.width, inputImg.height);
        else {
            if (maxWidth >= inputImg.width) resizeCanvas(maxHeight * imgRatio, maxHeight);
            else if (maxHeight >= inputImg.height) resizeCanvas(maxWidth, maxWidth / imgRatio);
            else if (maxWidth >= maxHeight * imgRatio) resizeCanvas(maxHeight * imgRatio, maxHeight);
            else resizeCanvas(maxWidth, maxWidth / imgRatio);
        }
    }
    else resizeCanvas(maxWidth, maxHeight);
}

function windowResized() {
    calculateResizeCanvas();
}

let kernelRadius = 1;
let kernelSize;
let kernel = [];
let sum;
let a = 0;

function generateKernel() {
    kernelRadius = parseInt(document.getElementById('radius-slider').value);
    kernelSize = kernelRadius * 2 + 1;
    kernel = [];
    sum = 0;
    let sigma = max(kernelRadius / 2, 1);

    for (let i = -kernelRadius; i < kernelRadius + 1; i++) {
        kernel[i + kernelRadius] = [];
        for (let j = -kernelRadius; j < kernelRadius + 1; j++) {
            let expNumerator = -(i * i + j * j);
            let expDenominator = 2 * sigma * sigma;
            let eExp = Math.exp(expNumerator / expDenominator);
            let kernelVal = eExp / (2 * PI * sigma * sigma);
            kernel[i + kernelRadius][j + kernelRadius] = kernelVal;
            sum += kernelVal;
        }
    }
    for (let i = 0; i < kernelSize; i++)
        for (let j = 0; j < kernelSize; j++)
            kernel[i][j] /= sum;

}

let w;
let h;
function filterImage() {
    w = inputImg.width;
    h = inputImg.height;
    outputImg = createImage(w, h);
    inputImg.loadPixels();
    outputImg.loadPixels();

    processFilter();
}

let j = 0;
function processFilter() {
    for (let i = 0; i < w; i++) {
        let sumR = 0;
        let sumG = 0;
        let sumB = 0;
        let sumA = 0;

        for (let x = 0; x < kernelSize; x++) {
            for (let y = 0; y < kernelSize; y++) {
                let xIndex = i + x - kernelRadius;
                if (xIndex < 0) xIndex = 0;
                else if (xIndex >= w) xIndex = w - 1;

                let yIndex = j + y - kernelRadius;
                if (yIndex < 0) yIndex = 0;
                else if (yIndex >= h) yIndex = h - 1;
                let tileIndex = (xIndex + yIndex * w) * 4;
                sumR += kernel[x][y] * inputImg.pixels[tileIndex];
                sumG += kernel[x][y] * inputImg.pixels[tileIndex + 1];
                sumB += kernel[x][y] * inputImg.pixels[tileIndex + 2];
                sumA += kernel[x][y] * inputImg.pixels[tileIndex + 3];
            }
        }

        let index = (i + j * w) * 4;
        let a = 1;
        outputImg.pixels[index] = sumR / a;
        outputImg.pixels[index + 1] = sumG / a;
        outputImg.pixels[index + 2] = sumB / a;
        outputImg.pixels[index + 3] = sumA / a;
    }

    j++;
    if (j < h) setTimeout(processFilter, 0);
    else {
        j = 0;
        outputImg.updatePixels();
        showInput = false;
        redraw();
        document.getElementById('file-input').value = "";
        document.getElementById('btn-start').disabled = false;
        document.getElementById('btn-download').disabled = false;
        document.getElementById('file-input').disabled = false;
        document.getElementById('input-overlay').classList.remove('overlay-show');
        document.getElementById('notification').classList.add('notification-show');
    }
}

function startFilter() {
    if (!inputImg) {
        alert('Please upload an image before pressing the start button.');
        return;
    }
    document.getElementById('btn-start').disabled = true;
    document.getElementById('btn-download').disabled = true;
    document.getElementById('file-input').disabled = true;
    document.getElementById('input-overlay').classList.add('overlay-show');
    generateKernel();
    filterImage();
}

function downloadOutput() {
    if (!outputImg) {
        alert('Download is not ready yet!');
        return;
    }
    outputImg.save('median-blur');
}

function updateRadiusLabel() {
    document.getElementById('radius-value').innerHTML = document.getElementById('radius-slider').value;
}
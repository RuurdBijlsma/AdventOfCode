document.addEventListener('DOMContentLoaded', init);

iterations = 5;
sizePerGrid = 25;

async function init() {
    input = await (await fetch('input.txt')).text();

    canvas = document.createElement('canvas');
    document.body.appendChild(canvas);
    ctx = canvas.getContext('2d');

    pattern = `.#.
..#
###`.split('\n')
        .map(r => r.split('')
            .map(i => i === '#'));

    rules = parseRules(input);

    draw(pattern, canvas, ctx);
    let iv = setInterval(() => {
        iterate();
        console.log(countEm(pattern));

        if (--iterations <= 0)
            clearInterval(iv);
    }, 100);
}

function countEm(pattern) {
    return pattern.map(p => p
        .reduce((a, b) => a + b)
    ).reduce((a, b) => a + b);
}

function iterate() {
    for (let divisor = 2; divisor <= pattern.length; divisor++)
        if (pattern.length % divisor === 0) {
            pattern = concatPattern(pattern, divisor);
            break;
        }

    draw(pattern, canvas, ctx);
}

function concatPattern(pattern, divisor) {
    let subPatterns = [];

    for (let y = 0; y < pattern.length; y += divisor) {
        let gridRow = [];
        for (let x = 0; x < pattern.length; x += divisor)
            gridRow.push(rules[pattern
                .slice(y, y + divisor)
                .map(row => row.slice(x, x + divisor))]);
        subPatterns.push(gridRow);
    }

    return concat2d(subPatterns);
}

function draw(patternGrid, canvas, ctx) {
    canvas.width = canvas.height = sizePerGrid * patternGrid.length;
    for (let y = 0; y < patternGrid.length; y++)
        for (let x = 0; x < patternGrid.length; x++) {
            if (!patternGrid[y][x]) continue;

            let xPos = x * sizePerGrid;
            let yPos = y * sizePerGrid;
            ctx.fillStyle = 'white';
            ctx.fillRect(xPos, yPos, sizePerGrid, sizePerGrid);
            ctx.fillStyle = 'maroon';
            ctx.fillRect(xPos, yPos, sizePerGrid * 0.9, sizePerGrid * 0.9);
        }
}

function concat2d(arrays) {
    let subSize = arrays[0][0].length;
    let result = new Array(arrays.length * subSize);
    for (let i = 0; i < result.length; i++)
        result[i] = new Array(arrays.length * subSize);

    for (let y = 0; y < arrays.length; y++) {
        for (let x = 0; x < arrays[y].length; x++) {

            let sub2dArray = arrays[y][x];
            for (let y1 = 0; y1 < sub2dArray.length; y1++) {
                let realY = subSize * y + y1;
                for (let x1 = 0; x1 < sub2dArray[y1].length; x1++) {
                    let realX = subSize * x + x1;
                    result[realY][realX] = sub2dArray[y1][x1];
                }
            }

        }
    }

    return result;
}

function parseRules(inputString) {
    let rules = inputString.split('\n')
        .map(r => r.split(' => ')
            .map(p => p.split('/')
                .map(r => r.split('')
                    .map(i => i === '#'))));
    let result = {};
    for (let rule of rules) {
        let input = rule[0];
        let output = rule[1];

        for (let i = 0; i < 4; i++) {
            input = sym(input);
            result[input] = output;
            input.reverse()
            result[input] = output;
        }
    }
    return result;
}

function sym(pattern) {
    let result = [];
    let size = pattern.length;
    for (let y = 0; y < size; y++) {
        result.push([])
        for (let x = 0; x < size; x++)
            result[y][x] = pattern[x][y];
    }

    return result;
}
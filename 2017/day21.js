document.addEventListener('DOMContentLoaded', init);

input = `../.. => #.#/.#./...
#./.. => .../..#/..#
##/.. => .#./##./###
.#/#. => ..#/#../##.
##/#. => ##./..#/#.#
##/## => ###/###/.##
.../.../... => ...#/#.##/.##./#..#
#../.../... => .###/#.##/##.#/##.#
.#./.../... => #.../.###/..#./#.##
##./.../... => .#.#/.###/##../#.##
#.#/.../... => .##./..../##.#/#...
###/.../... => ..##/.#.#/###./#..#
.#./#../... => .#.#/##.#/.#.#/.##.
##./#../... => ###./.###/#.../...#
..#/#../... => #.##/##../.#../.##.
#.#/#../... => ..##/..../..##/...#
.##/#../... => ####/#..#/.#../....
###/#../... => ##../..#./##../....
.../.#./... => .###/...#/#.../#...
#../.#./... => .#../.#.#/..##/#.#.
.#./.#./... => ##.#/####/.#.#/##..
##./.#./... => ..../.###/#.#./..##
#.#/.#./... => ..#./..#./..../....
###/.#./... => ###./..../..#./....
.#./##./... => ..../.##./##.#/....
##./##./... => ..#./.#../..##/#...
..#/##./... => #.##/.##./..#./.##.
#.#/##./... => .###/#.../##.#/..#.
.##/##./... => ###./##../..#./..##
###/##./... => ..#./.##./.###/#..#
.../#.#/... => ###./#.../####/#.#.
#../#.#/... => .##./.#../#.##/.#..
.#./#.#/... => .#../##../..##/.#.#
##./#.#/... => ###./#.#./##.#/##..
#.#/#.#/... => #.../.##./#.##/#.#.
###/#.#/... => ###./..##/#.##/###.
.../###/... => ##../...#/#.#./#.#.
#../###/... => .#../...#/##.#/####
.#./###/... => #.#./..##/#.#./.##.
##./###/... => ..##/..##/.###/#...
#.#/###/... => ####/##../..../#..#
###/###/... => ...#/#.##/#.##/#.#.
..#/.../#.. => .#.#/..##/#.##/#..#
#.#/.../#.. => ...#/..#./##../#..#
.##/.../#.. => ####/##../..../##..
###/.../#.. => ..#./..#./##.#/#..#
.##/#../#.. => .#../####/.###/#..#
###/#../#.. => ####/.#.#/...#/..##
..#/.#./#.. => #.#./.##./####/....
#.#/.#./#.. => ##../###./.#../##..
.##/.#./#.. => ###./.#../...#/....
###/.#./#.. => .#../.###/##../##.#
.##/##./#.. => .#../#..#/.###/#...
###/##./#.. => ..../.##./##../...#
#../..#/#.. => ##.#/...#/.###/##.#
.#./..#/#.. => ##../##../..../#.#.
##./..#/#.. => ..##/.#../#.#./.#.#
#.#/..#/#.. => ..../..##/...#/...#
.##/..#/#.. => #.../..##/...#/####
###/..#/#.. => #.../..#./##.#/.#.#
#../#.#/#.. => ..##/#.../#..#/..#.
.#./#.#/#.. => #..#/#.../.##./#.##
##./#.#/#.. => ##.#/.##./##.#/...#
..#/#.#/#.. => ####/.#.#/.##./#.#.
#.#/#.#/#.. => #..#/.##./.##./.###
.##/#.#/#.. => ...#/...#/..../.##.
###/#.#/#.. => .#../###./..../.###
#../.##/#.. => ##.#/##../#.#./...#
.#./.##/#.. => ###./.#.#/#.##/####
##./.##/#.. => #.##/..#./.#../#..#
#.#/.##/#.. => #.#./..##/..##/.#.#
.##/.##/#.. => .#../.###/.###/#.##
###/.##/#.. => #.../##../#.#./.#..
#../###/#.. => #.#./###./.##./..#.
.#./###/#.. => #.../#.../.##./.#..
##./###/#.. => ..#./.###/..##/#...
..#/###/#.. => #.##/.#../###./.###
#.#/###/#.. => .#.#/#..#/###./##..
.##/###/#.. => #.#./#.##/..##/.#..
###/###/#.. => ##../#.../..#./#..#
.#./#.#/.#. => #..#/####/#.#./#..#
##./#.#/.#. => ..##/.#../##.#/#..#
#.#/#.#/.#. => ####/#.#./#..#/#.#.
###/#.#/.#. => #.../##.#/..../#...
.#./###/.#. => ..##/.##./####/.###
##./###/.#. => .##./..#./#.##/#..#
#.#/###/.#. => ##.#/##../####/...#
###/###/.#. => ..##/####/...#/.#..
#.#/..#/##. => #.##/.#.#/#.#./#.##
###/..#/##. => ...#/##.#/#..#/..#.
.##/#.#/##. => .#.#/..#./..../###.
###/#.#/##. => ###./####/##.#/#.##
#.#/.##/##. => ##.#/#.##/.##./##..
###/.##/##. => .#.#/#.#./###./####
.##/###/##. => .#../####/.#../....
###/###/##. => .#../..../##.#/.##.
#.#/.../#.# => #.../#.../..##/..##
###/.../#.# => ...#/..#./##.#/####
###/#../#.# => .###/..##/.#../....
#.#/.#./#.# => ###./####/.#../#..#
###/.#./#.# => #.../#.##/..../###.
###/##./#.# => .###/####/#..#/.###
#.#/#.#/#.# => .#.#/...#/.#.#/#.##
###/#.#/#.# => ..../..#./..#./####
#.#/###/#.# => ..##/...#/.#.#/.##.
###/###/#.# => .###/.##./..##/####
###/#.#/### => #.#./.#../.#.#/#.#.
###/###/### => #..#/##../#.#./####`;
iterations = 5;

// input = `../.# => ##./#../...
// .#./..#/### => #..#/..../..../#..#`;
// iterations = 2;

sizePerGrid = 10;

function init() {
    canvas = document.createElement('canvas');
    document.body.appendChild(canvas);
    ctx = canvas.getContext('2d');

    pattern = `.#.
..#
###`.split('\n')
        .map(r => r
            .split('')
            .map(i => i === '#')
        );

    rules = parseRules(input);

    // for (let i = 0; i < iterations; i++) {
    // 	iterate();
    // }

    draw(pattern, canvas, ctx);
    let iv = setInterval(() => {
        iterate();
        console.log(countEm(pattern));

        if (--iterations <= 0) {
            // alert(countEm(pattern));
            clearInterval(iv);
        }
    }, 200);
}

function countEm(pattern) {
    let count = 0;
    let size = pattern.length;
    for (let y = 0; y < size; y++) {
        for (let x = 0; x < size; x++) {
            if (pattern[y][x]) {
                count++;
                ctx.fillStyle = 'blue';
                ctx.fillRect(sizePerGrid * x, sizePerGrid * y, sizePerGrid / 1.1, sizePerGrid / 1.1);
            }
        }
    }
    return count;
}

function iterate() {
    let size = pattern.length;
    for (let divisor = 2; divisor <= size; divisor++)
        if (size % divisor === 0) {
            let res = concatPattern(pattern, divisor, size);
            if (!res)
                continue;
            pattern = res;
            break;
        }

    draw(pattern, canvas, ctx);
}

function concatPattern(pattern, divisor, size) {
    let subPatterns = [];

    for (let y = 0; y < size; y += divisor) {
        let gridRow = [];
        for (let x = 0; x < size; x += divisor) {
            let inputSubPattern = pattern
                .slice(y, y + divisor)
                .map(row => row.slice(x, x + divisor));

            let key = inputSubPattern.toString();
            if (rules.hasOwnProperty(key))
                gridRow.push(rules[key]);
            else {
                console.warn('no output found for input', inputSubPattern);
                return false;
            }
        }
        subPatterns.push(gridRow);
    }

    return concat2d(subPatterns);
}

function draw(patternGrid, canvas, ctx) {
    let size = patternGrid.length;
    canvas.width = canvas.height = sizePerGrid * size;
    for (let y = 0; y < size; y++) {
        for (let x = 0; x < size; x++) {
            if (!patternGrid[y][x]) continue;

            let xPos = x * sizePerGrid;
            let yPos = y * sizePerGrid;
            ctx.fillStyle = 'white';
            ctx.fillRect(xPos, yPos, sizePerGrid, sizePerGrid);
        }
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
                let realX = subSize * y + y1;
                for (let x1 = 0; x1 < sub2dArray[y1].length; x1++) {
                    let realY = subSize * x + x1;
                    result[realY][realX] = sub2dArray[y1][x1];
                }
            }
        }
    }

    return result;
}

function parseRules(inputString) {
    let rules = inputString
        .split('\n')
        .map(r => r
            .split(' => ')
            .map(p => p
                .split('/')
                .map(r => r
                    .split('')
                    .map(i => i === '#')
                )
            )
        );

    let result = {};
    for (let rule of rules) {
        let input = rule[0];
        let output = rule[1];

        for (let i = 0; i < 4; i++) {
            input = sym(clone(input));
            result[input] = output;
            input = flip(clone(input));
            result[input] = output;
        }
    }
    return result;
}

function rotate(matrix) {
    var n = matrix.length;
    for (var i = 0; i < n / 2; i++) {
        for (var j = 0; j < Math.floor(n / 2); j++) {
            var temp = matrix[i][j];
            matrix[i][j] = matrix[n - 1 - j][i];
            matrix[n - 1 - j][i] = matrix[n - 1 - i][n - 1 - j];
            matrix[n - 1 - i][n - 1 - j] = matrix[j][n - 1 - i];
            matrix[j][n - 1 - i] = temp;
        }
    }
    return matrix;
}

function clone(obj) {
    return JSON.parse(JSON.stringify(obj));
}

function sym(pattern) {
    let result = [];
    let size = pattern.length;
    for (let y = 0; y < size; y++) {
        result.push([])
        for (let x = 0; x < size; x++) {
            result[y][x] = pattern[x][y];
        }
    }

    return result;
}

function flip(pattern) {
    return pattern.reverse();
}
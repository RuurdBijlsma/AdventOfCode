knotHash = string => {

    let array = Object.keys([...new Array(256)]).map(n => +n);
    let input = string.split('').map(n => n.charCodeAt()).concat([17, 31, 73, 47, 23]);

    let reverseSubset = (arr, index, subLength) => {
        let newArr = [...arr];
        let doubleArr = [...arr, ...arr];
        let subset = doubleArr.splice(index, subLength).reverse();

        for (let i = 0; i < subset.length; i++) {
            let arrIndex = (index + i) % newArr.length;
            newArr[arrIndex] = subset[i];
        }

        return newArr;
    }

    let currentPosition = 0;
    let skipSize = 0;

    for (let round = 0; round < 64; round++)
        for (let i = 0; i < input.length; i++) {

            let length = input[i];

            array = reverseSubset(array, currentPosition, length);

            currentPosition += length + skipSize++;
            currentPosition %= array.length;

        }

    let denseHash = [];
    for (let i = 0; i < 16; i++) {
        let subset = array.slice(i * 16, (i + 1) * 16)
        denseHash.push(subset.reduce((a, b) => a ^ b))
    }

    return denseHash.map(d => d.toString(16)).map(n => n.length == 1 ? '0' + n : n).join('');
}

getHashes = input => {
    let hashes = [];

    for (let i = 0; i < 128; i++) {
        let preHash = input + '-' + i;
        let hash = knotHash(preHash);
        hashes.push(hash);
    }

    return hashes;
}

hashesToBinary = hashes => hashes.map(h => h.split('').map(s => parseInt(s, 16).toString(2).padStart(4, '0')).join(''))

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////PART 1//////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

hashesToBinary(getHashes('ljoxqyyw')).map(h => h.replace(/0/g, '').length).reduce((a, b) => a + b);

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////PART 2//////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

markNeighbours = (hashes, x, y) => {
    hashes[x][y] = '-';

    let neighbours = [
        [1, 0],
        [0, -1],
        [-1, 0],
        [0, 1]
    ];
    for (let neighbour of neighbours) {
        let nX = x + neighbour[0];
        let nY = y + neighbour[1];
        if (hashes[nX] !== undefined && hashes[nX][nY] === '1')
            markNeighbours(hashes, nX, nY);
    }
};

hashes = hashesToBinary(getHashes('ljoxqyyw')).map(h => h.split(''));

regions = 0;
for (let x = 0; x < hashes.length; x++)
    for (let y = 0; y < hashes[x].length; y++)
        if (hashes[x][y] === '1') {
            regions++;
            markNeighbours(hashes, x, y);
        }

regions
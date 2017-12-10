
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////PART 1//////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

array = Object.keys([...new Array(256)]).map(n => +n);
input = [18,1,0,161,255,137,254,252,14,95,165,33,181,168,2,188];

reverseSubset = (arr, index, subLength) => {
	let newArr = [...arr];
	let doubleArr = [...arr, ...arr];
	let subset = doubleArr.splice(index, subLength).reverse();

	for(let i = 0; i < subset.length; i++){
		let arrIndex = (index + i) % newArr.length;
		newArr[arrIndex] = subset[i];
    }

	return newArr;
}

currentPosition = 0;
skipSize = 0;

for(let i = 0; i < input.length; i++){

    length = input[i];

    array = reverseSubset(array, currentPosition, length);

    currentPosition += length + skipSize++;
    currentPosition %= array.length;

}

array


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////PART 2//////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

array = Object.keys([...new Array(256)]).map(n => +n);
input = `18,1,0,161,255,137,254,252,14,95,165,33,181,168,2,188`.split('').map(n=>n.charCodeAt()).concat([17, 31, 73, 47, 23]);

reverseSubset = (arr, index, subLength) => {
	let newArr = [...arr];
	let doubleArr = [...arr, ...arr];
	let subset = doubleArr.splice(index, subLength).reverse();

	for(let i = 0; i < subset.length; i++){
		let arrIndex = (index + i) % newArr.length;
		newArr[arrIndex] = subset[i];
    }

	return newArr;
}

currentPosition = 0;
skipSize = 0;

for(let round = 0; round < 64; round++)
for(let i = 0; i < input.length; i++){

    length = input[i];

    array = reverseSubset(array, currentPosition, length);

    currentPosition += length + skipSize++;
    currentPosition %= array.length;

}

denseHash = [];
for(let i=0;i<16;i++){
    let subset = array.slice(i*16, (i+1)*16)
	denseHash.push(subset.reduce((a,b) => a ^ b))
}

denseHash.map(d=>d.toString(16)).map(n=>n.length == 1 ? '0' + n : n).join('')

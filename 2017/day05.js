//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////// PART 1 //////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

jumps = input.split('\n').map(n => +n);

i = 0;
steps = 0;
while (true) {
    // 	console.log(jumps.join(' '))
    // 	console.log('^'.padStart((i*2)+1, ' '))

    value = jumps[i];
    jumps[i]++;
    i += value;

    steps++;

    if (i < 0 || i >= jumps.length)
        break;
}

steps

//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////// PART 2 //////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

jumps = input.split('\n').map(n => +n);

i = 0;
steps = 0;
while (true) {
    // 	console.log(jumps.join(' '))
    // 	console.log('^'.padStart((i*2)+1, ' '))

    value = jumps[i];
    jumps[i] += value >= 3 ? -1 : 1;
    i += value;

    steps++;

    if (i < 0 || i >= jumps.length)
        break;
}

steps
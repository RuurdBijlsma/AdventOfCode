distOnce = banks => {

    let highestNumber = Math.max(...banks);
    let highestIndex = banks.indexOf(highestNumber);
    let startIndex = (highestIndex + 1) % banks.length;
    banks[highestIndex] = 0;

    for (let bankIndex = startIndex; bankIndex < banks.length; bankIndex++) {
        banks[bankIndex]++;
        highestNumber--;
        if (highestNumber <= 0)
            break;

        if (bankIndex >= banks.length - 1)
            bankIndex = -1;
    }

    return banks;

}

part1 = banks => {

    let memory = [];
    let redistributionCycles = 0;

    while (memory.find(b => b.toString() === banks.toString()) === undefined) {
        memory.push(banks);
        banks = distOnce([...banks]);
        console.log(banks);
        redistributionCycles++;
    }

    return redistributionCycles
}

part2 = banks => {

    let memory = [];
    let redistributionCycles = 0;

    while (memory.find(b => b.toString() === banks.toString()) === undefined) {
        memory.push(banks);
        banks = distOnce([...banks]);
        redistributionCycles++;
    }

    let lastSeenIndex = memory.findIndex(b => b.toString() === banks.toString());

    return redistributionCycles - lastSeenIndex;
}
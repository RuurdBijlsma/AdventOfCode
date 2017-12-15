function* Generate(startValue, factor, modValue = 1) {
    while (true) {
        do {
            startValue *= factor;
            startValue %= 2147483647;
        } while (startValue % modValue !== 0);
        yield startValue & 0xFFFF;
    }
}

function* Zip(...generators) {
    while (true)
        yield generators.map(g => g.next().value);
}

function* Take(limit, generator) {
    while (limit-- > 0)
        yield generator.next().value;
}

function* Filter(filterFunction, generator) {
    for (let value of generator)
        if (filterFunction(value))
            yield value;
}

function Count(generator){
    let count = 0;
    for (let value of generator)
        count++;
    return count;
}

judge = (startA, startB, take, modA = 1, modB = 1) => {
    ag = Generate(startA, 16807, modA);
    bg = Generate(startB, 48271, modB);

    return Count(Filter(([a, b]) => a === b, Take(take, Zip(ag, bg))))
}

part1 = judge(516, 190, 40000000);
part2 = judge(516, 190, 5000000, 4, 8);
part1 = () => {
    let n = 0;
    let state = [0];
    for (i = 1; i <= 2017; i++) {
        n = (n + 382 % i + 1) % i;
        state.splice(n, 0, i);
    }
    return state[state.indexOf(2017) + 1];
}
part1();

part2 = () => {
    let n = 0;
    let result = 0;
    for (i = 1; i <= 50000000; i++) {
        n = (n + 382 % i + 1) % i;
        if (n === 0)
            result = i;
    }
    return result;
}
part2();
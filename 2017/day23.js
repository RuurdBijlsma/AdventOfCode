now = performance.now();

operations = input.split('\n').map(o => o.split(' '));
programMap = {};
execute = programString => {
    programString = '()=>' + programString;
    if (programMap[programString] === undefined)
        programMap[programString] = eval(programString);
    return programMap[programString]();
}

run = operations => {
    mulCount = 0;
    eval('abcdefgh'.split('').map(l => l + '=0').join(';'));

    let ops = {
        set: '=',
        sub: '-=',
        mul: '*='
    }

    for (let i = 0; i < operations.length; i++) {
        let [operation, x, y] = operations[i];

        if (operation === 'mul')
            mulCount++;

        if (operation === 'jnz') {
            if (execute(x) !== 0)
                i += -1 + execute(y);
        } else execute(x + ops[operation] + y);
    }

    return mulCount;
}

console.log(run(operations), performance.now() - now);


//part1 manier 2
getMulCount = () => {
    let a = 0;
    let b = 0;
    let c = 0;
    let d = 0;
    let e = 0;
    let f = 0;
    let g = 0;
    let h = 0;
    let mCount = 0;

    b = 99
    c = b
    if (a !== 0) {

        b *= 100
        mCount++
        b += 100000
        c = b
        c += 17000
    }
    f = 1
    d = 2
    do {
        e = 2
        do {
            g = d
            g *= e
            mCount++
            g -= b
            if (g === 0)
                f = 0
            e += 1
            g = e
            g -= b
        } while (g !== 0)
        d += 1
        g = d
        g -= b
    } while (g !== 0)
    if (f === 0)
        h += 1
    g = b
    g = c
    b += 17

    return mCount;
}

//part 2
a = 1;
b = 0;
c = 0;
d = 0;
e = 0;
f = 0;
g = 0;
h = 0;

c = 109900 + 17000
for (let b = 109900; b <= c; b += 17) {
    outer:
    for (let d = 2; d <= b; d++) {
        for (let e = 2; e <= Math.ceil(b / d) + 1; e++) {
            if (d * e === b) {
                h++
                break outer
            }
        }
    }
}

h
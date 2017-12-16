spin = (programs, x) => {
    return programs.concat(programs).slice(programs.length - x, - x);
}

exchange = (programs, ai, bi) => {
    let temp = programs[ai];
    programs[ai] = programs[bi];
    programs[bi] = temp;
    return programs;
}

partner = (programs, a, b) => {
    return exchange(programs, programs.indexOf(a), programs.indexOf(b));
}

getMoves = input => input.split(',').map(m => {
    let type = m.slice(0, 1);
    let value = m.slice(1);
    let a, b;
    switch (type) {
        case 's':
            return programs => spin(programs, +value);
        case 'x':
            [a, b] = value.split('/').map(v => +v);
            return programs => exchange(programs, a, b);
        case 'p':
            [a, b] = value.split('/');
            return programs => partner(programs, a, b);
    }
});

programs = 'abcdefghijklmnop'.split('');

moves = getMoves(input);

dance = times => {
    memory = [];
    for (let i = 0; i < times; i++) {
        ps = programs.join('');
        if (memory.includes(ps)) {
            console.log(memory[times % i]);
            return;
        }
        memory.push(ps);
        for (let move of moves)
            programs = move(programs);
    }
    return programs.join('');
}

dance(1000000000)
parsed = input.split('\n\n');
currentState = parsed[0].split('state ')[1][0];
iterations = +parsed[0].split('\n')[1].split('after ')[1].split(' steps')[0];
states = {};
parsed.slice(1).map(s =>
	states[s.split('\n')[0].split('state ')[1][0]] = s.split('\n')
        .slice(1)
        .join('\n')
        .split('  If')
        .slice(1)
        .map(l => l.split('\n').map(op => op.trim()).slice(1))
		.map(op => {return {
            write: +op[0].split('value ')[1][0],
            move: op[1].split('to the ')[1].split('.')[0] === "left" ? -1 : 1,
            state: op[2].split('state ')[1][0]
        }}));

tape = {};
cursor = 0;
defaultValue = 0;

for(let i = 0; i < iterations; i++){
	let currentValue = tape[cursor] || defaultValue;
	let operation = states[currentState][currentValue];
	tape[cursor] = operation.write;
	cursor += operation.move;
	currentState = operation.state;
}

Object.values(tape).reduce((a,b)=>a+b)
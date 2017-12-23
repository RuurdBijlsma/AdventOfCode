now = performance.now();

operations = input.split('\n').map(o=>o.split(' '))

mulCount = 0;

programMap = {};
execute = programString => {
	programString = '()=>' + programString;
	if(programMap[programString] === undefined)
		programMap[programString] = eval(programString);
	return programMap[programString]();
}

run = operations => {
	eval('abcdefgh'.split('').map(l => l + '=0').join(';'));

	let ops = {
		set: '=',
		sub: '-=',
		mul: '*='
    }

    for(let i = 0; i < operations.length; i++){
        let [operation, x, y] = operations[i];
		
		if(operation === 'mul')
			mulCount++;

		if(operation === 'jnz'){
			if(execute(x) !== 0)
				i += -1 + execute(y);
        } else execute(x + ops[operation] + y);
    }

	return mulCount;
}

console.log(run(operations), performance.now() - now);
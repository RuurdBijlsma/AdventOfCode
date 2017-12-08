// Execute by typing part1(`inputstringhere`)
// Returns highest value in registry when completing all operations
part1 = (i, s = {}) => i.split('\n').forEach(l => s[l.split(' ')[0]] = +eval(`${s[l.split(' ')[0]] || 0}` + (eval(`${s[l.split(' ')[4]] || 0} ${l.split(' ').slice(-2).join(' ')}`) ? `${l.split(' ')[1] === 'inc' ? '+' : '-'} ${l.split(' ')[2]}` : ''))) ? '' : Math.max(...Object.values(s));

// Execute by typing part1(`inputstringhere`)
// Returns highest value in registry at any point
part2 = (i, s = {}) => Math.max(...i.split('\n').map(l => s[l.split(' ')[0]] = +eval(`${s[l.split(' ')[0]] || 0}` + (eval(`${s[l.split(' ')[4]] || 0} ${l.split(' ').slice(-2).join(' ')}`) ? `${l.split(' ')[1] === 'inc' ? '+' : '-'} ${l.split(' ')[2]}` : ''))));

//Part 1 in for loop
storage = {};
for (let line of input.split('\n')) {
    [variable, operation, value, _, conditionVariable, operator, conditionValue] = line.split(' ');
    currentValue = storage[variable] === undefined ? 0 : storage[variable];
    operation = `${operation === 'inc' ? '+' : '-'} ${value}`;
    condition = `${storage[conditionVariable] || 0} ${line.split(' ').slice(-2).join(' ')}`;
    newValue = +eval(`${currentValue}` + (eval(condition) ? operation : ''));
    storage[variable] = newValue;
}
Math.max(...Object.values(storage))

//Part 2 in for loop
storage = {};
values = []
for (let line of input.split('\n')) {
    [variable, operation, value, _, conditionVariable, operator, conditionValue] = line.split(' ');
    currentValue = storage[variable] === undefined ? 0 : storage[variable];
    operation = `${operation === 'inc' ? '+' : '-'} ${value}`;
    condition = `${storage[conditionVariable] || 0} ${line.split(' ').slice(-2).join(' ')}`;
    newValue = +eval(`${currentValue}` + (eval(condition) ? operation : ''));
    values.push(newValue);
    storage[variable] = newValue;
}
Math.max(values)
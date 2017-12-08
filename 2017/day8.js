// Execute by typing part1(`inputstringhere`)
// Returns highest value in registry when completing all operations
part1 = (i, s = {}) => i.split('\n').forEach(l => s[l.split(' ')[0]] = +eval(`${s[l.split(' ')[0]] || 0}` + (eval(`${s[l.split(' ')[4]] || 0} ${l.split(' ').slice(-2).join(' ')}`) ? `${l.split(' ')[1] === 'inc' ? '+' : '-'} ${l.split(' ')[2]}` : ''))) ? '' : Math.max(...Object.values(s));

// Execute by typing part1(`inputstringhere`)
// Returns highest value in registry at any point
part2 = (i, s = {}) => Math.max(...i.split('\n').map(l => s[l.split(' ')[0]] = +eval(`${s[l.split(' ')[0]] || 0}` + (eval(`${s[l.split(' ')[4]] || 0} ${l.split(' ').slice(-2).join(' ')}`) ? `${l.split(' ')[1] === 'inc' ? '+' : '-'} ${l.split(' ')[2]}` : ''))));
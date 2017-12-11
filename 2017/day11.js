steps = input.split(',');

y = 0;
x = 0;
z = 0;
positions = [];
for (let step of steps) {
    switch (step) {
        case 'n':
            y++;
            z--;
            positions.push([x, y, z]);
            break;
        case 'ne':
            z--;
            x++;
            positions.push([x, y, z]);
            break;
        case 'se':
            y--;
            x++;
            positions.push([x, y, z]);
            break;
        case 's':
            y--;
            z++;
            positions.push([x, y, z]);
            break;
        case 'sw':
            x--;
            z++;
            positions.push([x, y, z]);
            break;
        case 'nw':
            y++;
            x--;
            positions.push([x, y, z]);
            break;
    }
}

distanceFromPosition = (x, y, z) => [x, y, z].reduce((a, b) => Math.abs(a) + Math.abs(b)) / 2;

part1 = distanceFromPosition(x, y, z);
part2 = Math.max(...positions.map(p => distanceFromPosition(p[0], p[1], p[2])));
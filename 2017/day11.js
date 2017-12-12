steps = input.split(',');

directions = {
    'n': [0, 1, -1],
    'ne': [1, 0, -1],
    'se': [1, -1, 0],
    's': [0, -1, 1],
    'sw': [-1, 0, 1],
    'nw': [-1, 1, 0]
}

position = [0, 0, 0];
positions = [];
for (let step of steps) {
    position = position.map((n, i) => n + directions[step][i]);
    positions.push([...position]);
}

distanceFromPosition = (x, y, z) => [x, y, z].reduce((a, b) => Math.abs(a) + Math.abs(b)) / 2;

part1 = distanceFromPosition(position[0], position[1], position[2]);
part2 = Math.max(...positions.map(p => distanceFromPosition(p[0], p[1], p[2])));
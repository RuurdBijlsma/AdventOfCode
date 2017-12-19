day19 = input => {
    let grid = input.split('\n').map(n => n.split(''));

    let pos = [grid[0].indexOf('|'), 0];
    let directions = { up: [0, -1], right: [1, 0], down: [0, 1], left: [-1, 0] };
    let currentDirection = 'down';
    let lines = ['-', '|', '+'];
    let letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('');
    let opposite = { right: 'left', left: 'right', up: 'down', down: 'up' };
    let get = (x, y) => grid[y] === undefined ? false : grid[y][x] || false;
    let posChanged = true;
    let visited = [];
    let steps = 1;

    while (posChanged) {
        steps++;
        posChanged = false;

        let checkDirection = direction => {
            let dirPos = directions[direction];
            let neighbourPos = [pos[0] + dirPos[0], pos[1] + dirPos[1]];
            let neighbour = get(neighbourPos[0], neighbourPos[1]);

            if ([...lines, ...letters].includes(neighbour)) {
                if (letters.includes(neighbour)) visited.push(neighbour);
                currentDirection = direction;
                pos = neighbourPos;
                posChanged = true;
                return true;
            }
            return false;
        };

        if (checkDirection(currentDirection)) continue;

        for (let direction in directions) {
            if (opposite[currentDirection] === direction || currentDirection === direction)
                continue;
            if (checkDirection(direction)) break;
        }
    }

    return [visited.join(''), steps];
};

day19(input);
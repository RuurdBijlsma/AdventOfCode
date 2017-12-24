//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////// PART 1 ////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

tempGrid = input.split('\n').map(row => row.split('').map(i => i === '#'));
grid = {};
directions = [
    [0, 1], //up
    [1, 0], //right
    [0, -1], //down
    [-1, 0] //left
]
virusPos = [0, 0]
virusDirection = 0;

for (let y = 0; y < tempGrid.length; y++) {
    for (let x = 0; x < tempGrid[y].length; x++) {
        grid[[x - Math.floor(tempGrid[y].length / 2), -y + Math.floor(tempGrid.length / 2)]] = tempGrid[y][x];
    }
}

infections = 0;
for (let i = 0; i < 10000; i++) {
    if (grid[virusPos] === undefined)
        grid[virusPos] = false;

    if (grid[virusPos]) { //Current node is infected
        virusDirection = (virusDirection + 1) % directions.length;
    } else {
        virusDirection = (directions.length + virusDirection - 1) % directions.length;
        infections++;
    }
    grid[virusPos] = !grid[virusPos];
    virusPos[0] += directions[virusDirection][0];
    virusPos[1] += directions[virusDirection][1];
}

infections

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////// PART 2 ////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

state = {
    clean: 0,
    weak: 1,
    infected: 2,
    flagged: 3
}

tempGrid = input.split('\n').map(row => row.split('').map(i => i === '#' ? state.infected : state.clean));
grid = {};
directions = [
    [0, 1], //up
    [1, 0], //right
    [0, -1], //down
    [-1, 0] //left
]
virusPos = [0, 0]
virusDirection = 0;

for (let y = 0; y < tempGrid.length; y++) 
    for (let x = 0; x < tempGrid[y].length; x++) 
        grid[[x - Math.floor(tempGrid[y].length / 2), -y + Math.floor(tempGrid.length / 2)]] = tempGrid[y][x];

infections = 0;
for (let i = 0; i < 10000000; i++) {
    if (grid[virusPos] === undefined)
        grid[virusPos] = state.clean;

    switch (grid[virusPos]) {
        case state.clean:
            virusDirection = (virusDirection + directions.length - 1) % directions.length;
            break;
        case state.weak:
            infections++;
            break;
        case state.infected:
            virusDirection = (virusDirection + 1) % directions.length;
            break;
        case state.flagged:
            virusDirection = (virusDirection + 2) % directions.length;
            break;
    }

    grid[virusPos] = (grid[virusPos] + 1) % 4;
    virusPos[0] += directions[virusDirection][0];
    virusPos[1] += directions[virusDirection][1];
}

infections
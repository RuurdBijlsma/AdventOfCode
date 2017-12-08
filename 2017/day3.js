// Part 1

getCoordinate = number => {
    let startNum = 1,
        coord = [0, 0],
        directions = [
            [1, 0],
            [0, 1],
            [-1, 0],
            [0, -1]
        ],
        stepsPerDirection = 1,
        stepsTaken = 0,
        directionIndex = 0,
        directionChanges = 0;
    while (startNum !== number) {

        coord[0] += directions[directionIndex % 4][0];
        coord[1] += directions[directionIndex % 4][1];

        stepsTaken++;

        if (stepsTaken >= stepsPerDirection) {
            directionIndex++;
            stepsTaken = 0;
            directionChanges++;
            if (directionChanges % 2 === 0)
                stepsPerDirection++;
        }

        startNum++;
    }
    return coord;
};

getSteps = number => {
    let [x, y] = getCoordinate(number);
    return Math.abs(x) + Math.abs(y);
}

// Part 2
coordToIndex = searchCoord => {
  let [x, y] = searchCoord;
  if(x===0 && y===0)
    return 0;
    let startNum = 0,
        coord = [0, 0],
        directions = [[1, 0], [0, 1], [-1, 0], [0, -1]],
        stepsPerDirection = 1,
        stepsTaken = 0,
        directionIndex = 0,
        directionChanges = 0;
    while (x !== coord[0] || y !== coord[1]) {

        coord[0] += directions[directionIndex % 4][0];
        coord[1] += directions[directionIndex % 4][1];

        stepsTaken++;

        if (stepsTaken >= stepsPerDirection) {
            directionIndex++;
            stepsTaken = 0;
            directionChanges++;
            if (directionChanges % 2 === 0)
                stepsPerDirection++;
        }

        startNum++;
    }
    return startNum;
};

traverseMemory = number => {
  let startNum = 1,
        coord = [0, 0],
        directions = [[1, 0], [0, 1], [-1, 0], [0, -1]],
    neighbours = [[0, 1], [1, 1], [1, 0], [1, -1], [0, -1], [-1, -1], [-1, 0], [-1, 1]],
        stepsPerDirection = 1,
        stepsTaken = 0,
        directionIndex = 0,
        directionChanges = 0,
    memory = [];
    while (startNum - 1 < number) {
    memory.push(startNum);

        coord[0] += directions[directionIndex % 4][0];
        coord[1] += directions[directionIndex % 4][1];

        stepsTaken++;

        if (stepsTaken >= stepsPerDirection) {
            directionIndex++;
            stepsTaken = 0;
            directionChanges++;
            if (directionChanges % 2 === 0)
                stepsPerDirection++;
        }

    let myValue = 0;
    for(let neighbour of neighbours){
      let neighbourCoord = [];
      neighbourCoord[0] = coord[0] + neighbour[0];
      neighbourCoord[1] = coord[1] + neighbour[1];
      let neighbourMemoryIndex = coordToIndex(neighbourCoord);
      let neighbourValue = memory[neighbourMemoryIndex];
//       console.log(coord, neighbourCoord,neighbourMemoryIndex, neighbourValue);
      if(neighbourValue !== undefined)
        myValue+=neighbourValue;
        }
    startNum = myValue;
    }
    return startNum;
}
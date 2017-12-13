////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////PART 1///////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

layers = input.split('\n').map(l => l.split(': ').map(n => +n)).map(n => { return { depth: n[0], range: n[1], scannerPos: 0, direction: 1 }; });
firewallWidth = Math.max(...layers.map(l => l.depth));

simulateScanner = (delay, layers) => {
    for (let layer of layers)
        for (let i = 0; i < delay % (layer.range * 2 - 2); i++) {
            if (layer.scannerPos === layer.range - 1)
                layer.direction = -1;
            else if (layer.scannerPos === 0)
                layer.direction = 1;

            layer.scannerPos += layer.direction;
        }
}

layers = input.split('\n').map(l => l.split(': ').map(n => +n)).map(n => { return { depth: n[0], range: n[1], scannerPos: 0, direction: 1 }; });
firewallWidth = Math.max(...layers.map(l => l.depth));

severity = 0;
for (let programPos = 0; programPos <= firewallWidth; programPos++) {
    layer = layers.find(l => l.depth === programPos);

    caught = layer !== undefined && layer.scannerPos === 0;
    if (caught)
        severity += layer.depth * layer.range;

    simulateScanner(1, layers);
}
severity


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////PART 2///////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

ogLayers = input.split('\n').map(l => l.split(': ').map(n => +n)).map(n => { return { depth: n[0], range: n[1], scannerPos: 0, direction: 1 }; });
firewallWidth = Math.max(...ogLayers.map(l => l.depth));

simulateScanner = (delay, layers) => {
    for (let layer of layers)
        for (let i = 0; i < delay % (layer.range * 2 - 2); i++) {
            if (layer.scannerPos === layer.range - 1)
                layer.direction = -1;
            else if (layer.scannerPos === 0)
                layer.direction = 1;

            layer.scannerPos += layer.direction;
        }
}

for (let delay = 0;; delay++) {
    layers = JSON.parse(JSON.stringify(ogLayers));
    simulateScanner(delay, layers);
    caught = false;

    for (let programPos = 0; programPos <= firewallWidth; programPos++) {
        layer = layers.find(l => l.depth === programPos);

        caught = layer !== undefined && layer.scannerPos === 0;
        if (caught)
            break;

        simulateScanner(1, layers);
    }

    if (!caught) {
        console.log('success', delay);
        break;
    }

    if (delay % 1000 === 0)
        console.log('delay', delay);

    if (delay > 4000000)
        break;
}
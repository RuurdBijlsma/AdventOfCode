/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////// PART 1 ///////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

parts = input.split('\n').map(c => c.split('/').map(n => +n));

attachBridge = (parts, startPin, startStrength = 0) => {
    let strongest = startStrength;

    for (let i = parts.length - 1; i >= 0; i--) {
        if (!parts[i].includes(startPin))
            continue;

        let part = parts.splice(i, 1)[0];
        let partStrength = part[0] + part[1];
        let endPin = part[0] === startPin ? part[1] : part[0];
        let strength = attachBridge(parts, endPin, startStrength + partStrength);
        if (strength > strongest)
            strongest = strength;
        parts.splice(i, 0, part);
    }

    return strongest;
}

attachBridge(parts, 0);

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////// PART 2 ///////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

parts = input.split('\n').map(c => c.split('/').map(n => +n));

attachBridge = (parts, startPin, startStrength = 0, startLength = 0) => {
    let strongest = startStrength;
    let longest = startLength;

    for (let i = parts.length - 1; i >= 0; i--) {
        if (!parts[i].includes(startPin))
            continue;

        let part = parts.splice(i, 1)[0];
        let partStrength = part[0] + part[1];
        let endPin = part[0] === startPin ? part[1] : part[0];
        let [strength, length] = attachBridge(parts, endPin, startStrength + partStrength, startLength + 1);
        if (length >= longest && strength > strongest) {
            longest = length;
            strongest = strength;
        }
        parts.splice(i, 0, part);
    }

    return [strongest, longest];
}

attachBridge(parts, 0);
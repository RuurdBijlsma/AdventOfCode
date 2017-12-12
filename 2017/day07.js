// Part 1: 
// bottomProgram(input.split('\n'))

// Part 2: root.wrongWeight

bottomProgram = nodes => {
    let notBottom = [];

    for (let node of nodes) {
        if (node.includes('->')) {
            let children = node.split('-> ')[1].split(', ');
            for (let child of children) {
                notBottom = notBottom.concat(child);
            }
        }
    }

    for (let node of nodes) {
        let programName = node.split(' ')[0];
        if (!notBottom.includes(programName))
            return programName;
    }

    return false;
}

Program = class {
    constructor(name, weight, hasChildren) {
        this.name = name;
        this.weight = weight;
        this.hasChildren = hasChildren;
        this.children = [];
    }

    get childCount() {
        let sum = 0;
        if (this.hasChildren) {
            for (let child of this.children) {
                sum += child.childCount;
            }
        }
        return 1 + sum;
    }

    get fullWeight() {
        let sum = 0;
        if (this.hasChildren) {
            for (let child of this.children) {
                sum += child.fullWeight;
            }
        }
        return this.weight + sum;
    }

    hasBadChildren() {
        if (!this.hasChildren) return this;

        let weights = this.children.map(c => c.fullWeight);
        let maxWeight = Math.max(...weights);
        let avgWeight = weights.reduce((a, b) => a + b) / weights.length;
        if (maxWeight === avgWeight) {
            return this;
        }
        return this.children.find(c => c.fullWeight === maxWeight).hasBadChildren();
    }

    get wrongWeight() {
        let bois = this.hasBadChildren().parent.children;
        let weights = bois.map(c => c.fullWeight);
        let maxWeight = Math.max(...weights);
        let desiredWeight = bois.find(w => w.fullWeight !== maxWeight).fullWeight;
        let addage = maxWeight - desiredWeight;
        console.log('addage', addage);
        return bois.find(w => w.fullWeight === maxWeight).weight - addage;
    }
}

programs = [];

for (let i = 0; i < nodes.length; i++) {
    let node = nodes[i];
    let name = node.split(' ')[0];
    let weight = +node.split('(')[1].split(')')[0];
    let hasChildren = node.includes('->');
    let program = new Program(name, weight, hasChildren);
    programs.push(program);
}

for (let i = 0; i < nodes.length; i++) {
    let node = nodes[i];
    let program = programs[i];
    if (program.hasChildren) {
        let children = node.split('-> ')[1].split(', ');
        for (let child of children) {
            let childProgram = programs.find(p => p.name === child);
            program.children.push(childProgram);
            childProgram.parent = program;
        }
    }
}

rootName = bottomProgram(nodes);
root = programs.find(p => p.name === rootName);
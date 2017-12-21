Vec = class {
    constructor(x, y, z) {
        this.x = x;
        this.y = y;
        this.z = z;
    }

    manhattan() {
        return Math.abs(this.x) + Math.abs(this.y) + Math.abs(this.z);
    }

    add(vec) {
        this.x += vec.x;
        this.y += vec.y;
        this.z += vec.z;
    }

    distanceTo(vec) {
        let dx = this.x - vec.x;
        let dy = this.y - vec.y;
        let dz = this.z - vec.z;

        return Math.sqrt(dx * dx + dy * dy + dz * dz);
    }
}

parse = input => {
    let particles = input
        .split('\n')
        .map((p, i) => {
            let vecs = p.split(', ')
                .map(v => new Vec(
                    ...v.split('=<')[1]
                    .trim()
                    .replace(/>/g, '')
                    .split(',')
                    .map(n => +n)
                ));
            return { p: vecs[0], v: vecs[1], a: vecs[2], i };
        });

    return particles;
}

tick = particle => {
    let { p, v, a } = particle;
    v.add(a);
    p.add(v);
    return particle;
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////// PART 1 //////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

particles = parse(input);

for (let i = 0; i < 1000; i++)
    particles.forEach(tick);

particles.sort((a, b) => a.p.manhattan() - b.p.manhattan())[0];

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////// PART 2 //////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

removeCollisions = particles => {
    let remove = [];
    for (let i = 0; i < particles.length; i++) {
        if(remove.includes(i)) continue;
        let p1 = particles[i].p;
        for (let j = i + 1; j < particles.length; j++) {
            let p2 = particles[j].p;
            if (p1.x === p2.x && p1.y === p2.y && p1.z === p2.z) {
                if (!remove.includes(i))
                    remove.push(i);
                if (!remove.includes(j))
                    remove.push(j);
            }
        }
    }
    for (let i = remove.length - 1; i >= 0; i--) {
        particles.splice(remove[i], 1);
    }
}

particles = parse(input);

for (let i = 0; i < 1000; i++) {
    particles.forEach(tick);
    removeCollisions(particles);
}

particles.length;
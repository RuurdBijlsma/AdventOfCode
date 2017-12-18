input = `set i 31
set a 1
mul p 17
jgz p p
mul a 2
add i -1
jgz i -2
add a -1
set i 127
set p 735
mul p 8505
mod p a
mul p 129749
add p 12345
mod p a
set b p
mod b 10000
snd b
add i -1
jgz i -9
jgz a 3
rcv b
jgz b -1
set f 0
set i 126
rcv a
rcv b
set p a
mul p -1
add p b
jgz p 4
snd a
set a b
jgz 1 3
snd b
set f 1
add i -1
jgz i -11
snd a
jgz f -16
jgz a -19`;

///////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////// PART 1 /////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

Program = class {
    constructor(input) {
        this.lastSound = 0;

        this.commands = input.split('\n').map(c => {
            let [name, register, value = null] = c.split(' ');
            return { name, register, value };
        });

        this.registers = {};
    }

    get(value) {
        return isNaN(value) ? this.registers[value] || 0 : +value;
    }

    run() {
        let actions = {
            'set': (registers, key, value) => registers[key] = this.get(value),
            'add': (registers, key, value) => registers[key] += this.get(value),
            'mul': (registers, key, value) => registers[key] *= this.get(value),
            'mod': (registers, key, value) => registers[key] %= this.get(value)
        }

        for (let i = 0; i < this.commands.length; i++) {
            let command = this.commands[i];

            switch (command.name) {
                case 'jgz':
                    i += this.get(command.register) > 0 ? this.get(command.value) - 1 : 0;
                    break;
                case 'rcv':
                    return this.lastSound;
                case 'snd':
                    this.lastSound = this.get(command.register);
                    break;
                default:
                    actions[command.name](this.registers, command.register, command.value);
            }
        }
    }
}

new Program(input).run();

///////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////// PART 2 /////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////

Program = class {
    constructor(id, input) {
        this.id = id;
        this.queue = [];
        this.sendAmount = 0;
        this.waitIndex = 0;

        this.commands = input.split('\n').map(c => {
            let [name, register, value = null] = c.split(' ');
            return { name, register, value };
        });

        this.registers = { 'p': this.id };
    }

    get(value) {
        return isNaN(value) ? this.registers[value] || 0 : +value;
    }

    run(friendProgram, startIndex = 0) {
        let actions = {
            'set': (registers, key, value) => registers[key] = this.get(value),
            'add': (registers, key, value) => registers[key] += this.get(value),
            'mul': (registers, key, value) => registers[key] *= this.get(value),
            'mod': (registers, key, value) => registers[key] %= this.get(value)
        }

        for (let i = startIndex; i < this.commands.length; i++) {
            let command = this.commands[i];


            switch (command.name) {
                case 'jgz':
                    i += this.get(command.register) > 0 ? this.get(command.value) - 1 : 0;
                    break;
                case 'rcv':
                    if (this.queue.length === 0) {
                        if (friendProgram.queue.length !== 0) {
                            this.waitIndex = i;
                            friendProgram.run(this, friendProgram.waitIndex);
                        }
                        return;
                    }

                    let [value] = this.queue.splice(0, 1);
                    actions.set(this.registers, command.register, value);
                    break;
                case 'snd':
                    this.sendAmount++;
                    friendProgram.queue.push(this.get(command.register));
                    break;
                default:
                    actions[command.name](this.registers, command.register, command.value);
            }
        }
    }
}

p0 = new Program(0, input);
p1 = new Program(1, input);

p0.run(p1);

p1.sendAmount;
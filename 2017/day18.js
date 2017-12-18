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

        this.commands
            .filter(({ register }) => isNaN(register))
            .filter(({ register }) => register !== 'p')
            .forEach(({ register }) => this.registers[register] = 0);
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

            if (command.name === 'jgz')
                i += this.get(command.register) > 0 ? this.get(command.value) - 1 : 0;
            else if (command.name === 'rcv') {
				return this.lastSound;
            } else if (command.name === 'snd') {
				this.lastSound = this.get(command.register);
            } else 
                actions[command.name](this.registers, command.register, command.value);
        }
        return false;
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

        this.commands
            .filter(({ register }) => isNaN(register))
            .filter(({ register }) => register !== 'p')
            .forEach(({ register }) => this.registers[register] = 0);
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

            if (command.name === 'jgz')
                i += this.get(command.register) > 0 ? this.get(command.value) - 1 : 0;
            else if (command.name === 'rcv') {
                if (this.queue.length === 0) {
                    if (friendProgram.queue.length !== 0) {
                        this.waitIndex = i;
                        friendProgram.run(this, friendProgram.waitIndex);
                    }
                    break;
                }

                let [value] = this.queue.splice(0, 1);
                actions.set(this.registers, command.register, value);
            } else if (command.name === 'snd') {
                this.sendAmount++;
                friendProgram.queue.push(this.get(command.register));
            } else 
                actions[command.name](this.registers, command.register, command.value);
            

        }
        return false;
    }
}

p0 = new Program(0, input);
p1 = new Program(1, input);

p0.run(p1);

p1.sendAmount;
Group = class {
    get score() {
        return this.outerGroup === false ? 1 : this.outerGroup.score + 1;
    }

    get totalScore() {
        if (this.innerGroups.length === 0) {
            return this.score;
        } else {
            let sum = 0;
            for (let innerGroup of this.innerGroups) {
                sum += innerGroup.totalScore;
            }
            return sum + this.score;
        }
    }

    constructor(groupString, outerGroup = false) {
        this.garbageChars = 0;
        groupString = this.removeGarbage(groupString);
        // 		console.log('inner group',groupString);
        this.outerGroup = outerGroup;

        let insides = groupString.slice(1, groupString.length - 1);


        this.innerGroups = [];

        for (let i = 0; i < insides.length; i++) {

            if (insides[i] === '{') {
                let matchingIndex = this.findMatchingBraceIndex(insides, i) + 1;
                let innerGroupString = insides.slice(i, matchingIndex);
                let innerGroup = new Group(innerGroupString, this);
                this.innerGroups.push(innerGroup);
                i = matchingIndex;
            }
        }
    }

    removeGarbage(string) {
        let result = '';
        for (let i = 0; i < string.length; i++) {
            if (string[i] === '<') {
                this.garbageChars--;
                for (let j = i; j < string.length; j++) {
                    if (string[j] === '!') {
                        j++;
                        continue;
                    }
                    if (string[j] === '>') {
                        i = j;
                        break;
                    }
                    this.garbageChars++;
                }
            } else {
                result += string[i]
            }
        }
        return result;
    }

    findMatchingBraceIndex(string, index, startChar = '{', endChar = '}') {
        let braces = [];
        for (let i = index; i < string.length; i++) {
            if (string[i] === '!') {
                i++;
                continue;
            }
            if (string[i] === startChar) {
                braces.push(string[i]);
            }
            if (string[i] === endChar) {
                let pop = braces.pop();
                if (pop !== startChar)
                    braces.push(pop);

                if (braces.length === 0) {
                    return i;
                }
            }
        }
        console.warn('incorrect brace string found', string, index, startChar, endChar);
    }
}

input = `{<{o"i!a,<{i<a>}`;
group = new Group(input);
part1 = group.totalScore;
part2 = group.garbageChars;
import sequtils, sugar, tables, options, csp, constraint, algorithm

proc toSolution[T](assigned: TableRef[string, seq[T]]): TableRef[string, T] =
    result = newTable[string, T]()
    for key, value in assigned:
        if value.len > 0:
            result[key] = value[0]

proc partialAssignment[T](assigned: TableRef[string, seq[T]], unassigned: TableRef[string, seq[T]]):
    TableRef[string, seq[T]] =
    result = newTable[string, seq[T]]()
    for key, value in assigned:
        result[key] = value
    for key, value in unassigned:
        result[key] = value

proc enforceConsistency[T](
        assigned: TableRef[string, seq[T]],
        unassigned: TableRef[string, seq[T]],
        constraints: seq[Constraint[T]]
    ): Option[TableRef[string, seq[T]]] =
    proc removeInconsistentValues(constraint: Constraint[T], variables: TableRef[string, seq[T]]): bool =
        let head = constraint.variables[0]
        let tail = constraint.variables[1]
        var headValues = variables[head]
        var tailValues = variables[tail]

        # echo &"Head={head}, tail={tail}"
        # echo "head values"
        # echo headValues.join(" ")
        # echo "tail values"
        # echo tailValues.join(" ")

        var validTailValues = tailValues.filter((t) => headValues.any((h) => constraint.isSatisfied(h, t)))
        result = tailValues.len != validTailValues.len
        variables[tail] = validTailValues

    var binaryConstraints = constraints.filter((x) => x.variables.len == 2)
    proc incomingConstraints(tailKey: string): seq[Constraint[T]] =
        binaryConstraints.filter((x) => x.variables[0] == tailKey)

    var variables = partialAssignment(assigned, unassigned)
    # makes copy of sequence:
    var queue = binaryConstraints

    # process unary constraints
    for constraint in constraints.filter((c) => c.variables.len == 1):
        # echo &"unary constraint: {constraint}"
        let varKey  = constraint.variables[0]
        variables[varKey] = variables[varKey].filter((v) => constraint.isSatisfied(v))
        if variables[varKey].len == 0:
            return none(TableRef[string, seq[T]])

    # echo "Variables left in C:"
    # echo variables["C"].join(" ")

    # echo "queue"
    # echo queue.join(" ")

    while queue.len > 0:
        let constraint = queue.pop()
        let tail = constraint.variables[1]
        # echo &"Checking constraint {constraint}, the tail has values:"
        # echo variables[tail].join(" ")
        if removeInconsistentValues(constraint, variables):
            # echo "Removed inconsistent values from constraint, the tail now has values:"
            # echo variables[tail].join(" ")
            if variables[tail].len == 0:
                # echo "tail possibilities is empty, returning none"
                return none(TableRef[string, seq[T]])
            queue = queue.concat(incomingConstraints(tail))

    return some(variables)

# LCV: Least constraining value
proc orderValues[T](nextKey: string, assigned: TableRef[string, seq[T]], unassigned: TableRef[string, seq[T]], csp: CSP[T]): auto =
    if not csp.lcv:
        return unassigned[nextKey]

    proc countValues(vars: Option[TableRef[string, seq[T]]]): auto =
        if vars.isNone:
            return 0
        let variables = vars.get()
        var sum = 0
        for key, value in variables:
            sum += value.len
        return sum

    proc valuesEliminated(val: T): auto =
        assigned[nextKey] = @[val]
        let newLength = countValues(enforceConsistency(assigned, unassigned, csp.constraints))
        assigned.del(nextKey)
        return newLength

    let cache = newTable[T, int]()
    var values = unassigned[nextKey]
    for value in values:
        cache[value] = valuesEliminated(value)

    values.sort((a: T, b: T) => cache[b] - cache[a]);
    return values;

# MRV: Minimum Remaining Values
proc selectVariableKey[T](unassigned: TableRef[string, seq[T]], csp: CSP[T]): string =
    if not csp.mrv:
        for key, value in unassigned:
            return key

    var minLen = high(int);
    for key, value in unassigned:
        if value.len < minLen:
            result = key;
            minLen = value.len;

proc backtrack[T](
        assigned: TableRef[string, seq[T]],
        unassigned: TableRef[string, seq[T]],
        csp: CSP[T],
        solutionLimit = int.high,
    ): bool =
        if unassigned.len == 0:
            csp.solutions.add toSolution(assigned)
            # echo "Unassigned is empty, returning true"
            return true

        var nextKey = selectVariableKey(unassigned, csp)
        # echo &"Next key = {nextKey}"
        var values = orderValues(nextKey, assigned, unassigned, csp)
        # echo &"values = "
        # echo values.join(" ")
        unassigned.del(nextKey)

        for value in values:
            assigned[nextKey] = @[value]
            let consistentResult = enforceConsistency[T](assigned, unassigned, csp.constraints)
            if consistentResult.isNone:
                # echo "consistent result is none, continuing"
                continue
            # echo "consistent result is not none"
            let consistent = consistentResult.get()
            let newUnassigned = newTable[string, seq[T]]()
            let newAssigned = newTable[string, seq[T]]()

            var emptyFound = false
            for key, value in consistent:
                if value.len == 0:
                    emptyFound = true
                    break

                if key in assigned:
                    newAssigned[key] = assigned[key]
                else:
                    newUnassigned[key] = consistent[key]

            if emptyFound:
                echo "this isn't a valid path"
                continue

            csp.steps += 1

            if backtrack(newAssigned, newUnassigned, csp, solutionLimit) and csp.solutions.len >= solutionLimit:
                # echo "Returning true 2"
                return true

        # echo "Returning false"
        return false

proc solve*[T](variables: TableRef[string, seq[T]], constraints: seq[Constraint], solutionLimit = int.high): Option[CSP[T]] =
    var assigned = newTable[string, seq[T]]()
    let csp = newCSP[T](variables, constraints)
    discard backtrack(assigned, csp.variables, csp, solutionLimit)
    if csp.solutions.len == 0:
        return none(CSP[T])
    some(csp)
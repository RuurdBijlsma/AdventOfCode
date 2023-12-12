import tables, strformat, constraint

type
    CSP*[T] = ref object of RootObj
        solutions*: seq[TableRef[string, T]]
        steps*: int

        constraints*: seq[Constraint[T]]
        variables*: TableRef[string, seq[T]]

        mrv*: bool
        lcv*: bool

proc newCSP*[T](variables: TableRef[string, seq[T]], constraints: seq[Constraint[T]]): CSP[T]=
    result = new(CSP[T])
    result.mrv = true
    result.lcv = false
    result.solutions = newSeq[TableRef[string, T]]()
    result.steps = 0
    result.constraints = constraints
    result.variables = variables

proc `$`*(c: CSP): string =
    # let constraints = ($c.constraints).substr(0, 60) & "..."
    # let variables = ($c.variables).substr(0, 60) & "..."
    let solutions = c.solutions.join(" ")
    &"{{CSP solutions: {solutions}, steps: {c.steps}, solutionCount: {c.solutions.len}, mrv: {c.mrv}, lcv: {c.lcv} }}"
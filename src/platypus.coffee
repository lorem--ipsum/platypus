mod = angular.module 'platypus', ['platypus.grammar']

mod.factory "platypusUtils", ->
  equals = (rhs) ->
    if rhs instanceof Array
      return (a) -> rhs.indexOf(a) isnt -1

    return (a) -> a is rhs

  notequals = (rhs) ->
    if rhs instanceof Array
      return (a) -> rhs.indexOf(a) is -1

    return (a) -> a isnt rhs

  between = (rhs) ->
    if rhs[0] > rhs[1]
      return (a) -> rhs[0] >= a >= rhs[1]
    else
      return (a) -> rhs[0] <= a <= rhs[1]

  contains = (rhs) ->
    if rhs instanceof Array
      return (a) -> rhs.every (d) -> d.indexOf(a) is -1

    return (a) -> a.search(rhs) isnt -1

  comparator = (how, rhs) ->
    switch how
      when "is", "==" then return equals(rhs)
      when "is not", "!=" then return notequals(rhs)
      when "is between" then return between(rhs)
      when "contains" then return contains(rhs)
      else throw "Unknown comparator : " + how

  bool = {
    "or": (items, left, right) ->
      if isSimple(left) and isSimple(right)
        leftComp = comparator(left.operator, left.value)
        rightComp = comparator(right.operator, right.value)

        return items.filter (d) ->
          return leftComp(d[left.field]) or rightComp(d[right.field])
      else
        lefty = evaluate(items, left)
        righty = evaluate(items, right)

        return (lefty.filter (d) -> righty.indexOf(d) is -1).concat(righty)

    "and": (items, left, right) ->
      lefty = evaluate(items, left)
      righty = evaluate(items, right)

      return lefty.filter (d) -> righty.indexOf(d) isnt -1
  }

  isSimple = (condition) ->
    return !condition.and? and !condition.or?


  evaluate = (items, ast) ->
    if not ast.or? and not ast.and?
      return evaluateItem(ast, items)

    if ast.or?
      return bool.or(items, ast.or[0], ast.or[1])
    else if ast.and?
      return bool.and(items, ast.and[0], ast.and[1])

  evaluateItem = (condition, items) ->
    comp = comparator(condition.operator, condition.value)
    return items.filter (d) -> comp(d[condition.field])

  return {
    evaluate: evaluate
    comparator: comparator
  }

mod.filter "platypus", ["$grammar", "platypusUtils", ($grammar, platypusUtils) ->
  return (items, value) ->
    o = {}
    o.data = items unless !items

    return o unless !!value

    try
      if value instanceof Object
        o.data = platypusUtils.evaluate(items, value)
      else
        o.data = platypusUtils.evaluate(items, $grammar.parser.parse(value))
    catch e
      o.data = undefined
      o.error = e.message

    return o
]

describe 'grammar', ->

  parser = undefined

  beforeEach module "platypus.grammar"

  beforeEach inject ($grammar) ->
    parser = $grammar.parser

  it 'should return empty ast for empty string', ->
    expect(parser.parse("")).toBe(undefined)

  it 'should parse a simple condition', ->
    expect(parser.parse("foo is 7")).toEqual(
      { field : 'foo', operator : 'is', value : 7 }
    )

  it 'should parse a simple condition with multiple values', ->
    expect(parser.parse("foo is 7 or 8")).toEqual(
      { field : 'foo', operator : 'is', value : [7, 8] }
    )

  it 'should know the "contains" comparator', ->
    expect(parser.parse('foo contains "bar"')).toEqual(
      { field : 'foo', operator : 'contains', value : "bar" }
    )

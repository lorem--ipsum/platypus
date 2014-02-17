describe 'filter', ->

  parser = undefined
  filter = undefined
  items = undefined

  beforeEach module "platypus"

  beforeEach inject ($filter, $grammar) ->
    parser = $grammar.parser
    filter = $filter('platypus')

  beforeEach ->
    items = [
      {id: 0, name: "foo", email: "foo@foo.com"}
      {id: 1, name: "bar", email: "bar@bar.com"}
      {id: 2, name: "baz", email: "baz@baz.com"}
      {id: 3, name: "qux", email: "qux@qux.com"}
      {id: 4, name: "qux", email: "qux@qux.com"}
    ]

  describe 'simple AST', ->
    it 'should filter with simple value', ->
      ast = parser.parse('name is "bar"')
      expect(filter(items, ast).data).toEqual([items[1]])

    it 'should filter with multiple values', ->
      ast = parser.parse('name is "bar" or "baz"')
      expect(filter(items, ast).data).toEqual([items[1], items[2]])

    it 'should filter from a OR group', ->
      ast = parser.parse('name is "bar" or name is "baz"')
      expect(filter(items, ast).data).toEqual([items[1], items[2]])

    it 'should avoid duplicates in OR', ->
      ast = parser.parse('name is "qux" or id is 3')
      expect(filter(items, ast).data).toEqual([items[3], items[4]])

    it 'should filter from a AND group', ->
      ast = parser.parse('name is "qux" and id is 3')
      expect(filter(items, ast).data).toEqual([items[3]])

    it 'should filter with a between condition', ->
      ast = parser.parse('id is between 2 and 4')
      expect(filter(items, ast).data).toEqual([items[2], items[3], items[4]])

  it 'should work with expression too', ->
    expect(filter(items, 'name is "bar"').data).toEqual([items[1]])

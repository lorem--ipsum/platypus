describe "platypusUtils", ->
  utils = undefined

  beforeEach module "platypus"

  beforeEach inject (platypusUtils) ->
    utils = platypusUtils

  describe "comparison", ->
    it 'should know "=="" and "is"', ->
      expect(utils.comparator("==", 2)(2)).toBeTruthy()
      expect(utils.comparator("==", [2, 3])(2)).toBeTruthy()
      expect(utils.comparator("is", 2)(2)).toBeTruthy()

      expect(utils.comparator("==", 2)(1)).toBeFalsy()
      expect(utils.comparator("is", 3)("2")).toBeFalsy()

    it 'should know "!="" and "is not"', ->
      expect(utils.comparator("!=", 2)(1)).toBeTruthy()
      expect(utils.comparator("!=", [2, 3])(1)).toBeTruthy()
      expect(utils.comparator("is not", 2)("2")).toBeTruthy()

      expect(utils.comparator("!=", 2)(2)).toBeFalsy()
      expect(utils.comparator("is not", 2)(2)).toBeFalsy()

    it 'should know "between"', ->
      expect(utils.comparator("is between", [2, 4])(3)).toBeTruthy()
      expect(utils.comparator("is between", [2, 3])(3)).toBeTruthy()
      expect(utils.comparator("is between", [2, 3])(4)).toBeFalsy()

    it 'should know "contains"', ->
      expect(utils.comparator("contains", "foo")("boofoobar")).toBeTruthy()
      expect(utils.comparator("contains", "foo")("bookoobar")).toBeFalsy()
      expect(utils.comparator("contains", ["foo", "bar"])("bookoobar")).toBeTruthy()


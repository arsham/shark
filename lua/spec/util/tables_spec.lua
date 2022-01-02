local assert = require('luassert')
local busted = require('plenary.busted')
local describe = busted.describe
local it = busted.it
local before_each = busted.before_each

local _t = require('util.tables').new

-- selene: allow(multiple_statements)
describe('Table', function()

  describe('table_len', function()
    it('zero length', function()
      assert.are.same(0, _t{}:table_len())
    end)

    it('should account for all items', function()
      local t = _t{a=1, 2, 3, b=40}
      assert.are.same(4, t:table_len())
    end)
  end)

  describe('filter', function()
    local t = _t{}

    before_each(function() t = _t{1, 2, 3} end)

    it('error when argument is not a function', function()
      assert.has.errors(function() t:filter() end)
      assert.has.errors(function() t:filter('aa') end)
    end)

    it('returns new table', function()
      local t2 = t:filter(function() return true end)
      table.insert(t2, 1)
      assert.is_not.same(t, t2)
    end)

    it('returns filtered table', function()
      local t2 = t:filter(function(v) return v > 1 end)
      assert.is_not.same(t, t2)
    end)

    it('filters maps too', function()
      local m = _t{1, 2, a=1, b=2}
      local t2 = m:filter(function(v) return v > 1 end)
      assert.is_not.same(_t{1, b=2}, t2)
    end)
  end)

  describe('map', function()
    local t = _t{}

    before_each(function() t = _t{1, 2, 3, a=5} end)

    it('error when argument is not a function', function()
      assert.has.errors(function() t:map() end)
      assert.has.errors(function() t:map('aa') end)
    end)

    it('returns new table', function()
      local t2 = t:map(function(v) return v end)
      table.insert(t2, 1)
      assert.is_not.same(t, t2)
    end)

    it('applies the map', function()
      local t2 = t:map(function(v) return 2 * v end)
      assert.are.same(_t{2, 4, 6, a=10}, t2)
    end)
  end)

  describe('values', function()
    local t = _t{2, 3, a=7, 9}
    local original = vim.deepcopy(t)

    before_each(function()
      t = original
    end)

    it('returns new copy', function()
      local got = t:values()
      table.insert(got, 666)
      assert.are.same(t, original)
    end)

    it('returns empty for empty tables', function()
      assert.are.same(_t(), _t():values())
    end)

    it('returns values', function()
      assert.are.same(_t{2, 3, 7, 9}:sort(), t:values():sort())
    end)
  end)

  describe('slice', function()
    local t = _t{2, 3, a=7, 9, b=10, 11}
    local original_len = #t

    it('second to last', function()
      local got = t:slice(2)
      assert.are.same(_t{3, 9, 11}, got)
    end)

    it('returns new copy', function()
      t:slice(3)
      assert.are.same(original_len, #t)
    end)

    it('stepping', function()
      local got = t:slice(1, #t, 2)
      assert.are.same(_t{2, 9}, got)
    end)
  end)

  describe('merge', function()
    local t1 = _t{2, 3, a=7, 9, b=10, 11}
    local t2 = _t{3, a=3, 9, c=10, 13}

    it('two empty', function()
      local got = _t():merge(_t())
      assert.are.same(_t(), got)
    end)

    it('left empty', function()
      local got = _t():merge(t1)
      assert.are.same(t1, got)
    end)

    it('right empty', function()
      local got = t1:merge(_t())
      assert.are.same(t1, got)
    end)

    it('do merge', function()
      local want = _t{2, 3, a=3, 9, b=10, c=10, 11, 13}
      local got = t1:merge(t2)
      assert.are.same(want, got:sort())
    end)
  end)

  describe('find_first', function()
    local t = _t{2, 3, 4, a=10, b=20, c=30}

    it('error when argument is not a function', function()
      assert.has.errors(function() t:find_first() end)
      assert.has.errors(function() t:find_first('aa') end)
    end)

    it('returns first match', function()
      local got = t:find_first(function(v) return v == 3 end)
      assert.are.same(3, got)
    end)

    it('returns nil when no match', function()
      local got = t:find_first(function(v) return v == 666 end)
      assert.is_nil(got)
    end)

    it('returns first match in maps too', function()
      local got = t:find_first(function(v) return v == 3 end)
      assert.are.same(3, got)
    end)
  end)

  describe('contains_fn', function()
    local t = _t{2, 3, 4, a=10, b=20, c=30}

    it('error when argument is not a function', function()
      assert.has.errors(function() t:contains_fn() end)
      assert.has.errors(function() t:contains_fn('aa') end)
    end)

    it('returns true when match', function()
      local got = t:contains_fn(function(v) return v == 3 end)
      assert.is_true(got)
    end)

    it('returns false when no match', function()
      local got = t:contains_fn(function(v) return v == 666 end)
      assert.is_false(got)
    end)

    it('returns true in maps too', function()
      local got = t:contains_fn(function(v) return v == 3 end)
      assert.is_true(got)
    end)
  end)

  describe('contains', function()
    local t = _t{2, 3, 4, a=10, b=20, c=30, {a=80}}

    it('returns false if no value is given', function()
      local got = t:contains()
      assert.is_false(got)
    end)

    it('returns true if value is in table', function()
      local got = t:contains(3)
      assert.is_true(got)
    end)

    it('returns false if value is not in table', function()
      local got = t:contains(666)
      assert.is_false(got)
    end)

    it('returns false if value is in deep', function()
      local got = t:contains(80)
      assert.is_false(got)
    end)

    it('returns true if value is a table in table', function()
      local got = t:contains({a=80})
      assert.is_true(got)
    end)

  end)

  describe('chunk', function()
    local t = _t{2, 3, 4, a=10, b=20, c=30, {a=80}, 10, 20}

    it('returns the same table if chunk size is >= as table length', function()
      local got = t:chunk(9)
      assert.are.same(t, got[1])
      got = t:chunk(10)
      assert.are.same(t, got[1])
      got = t:chunk(100)
      assert.are.same(t, got[1])
    end)

    it('returns the same table if chunk size is 0', function()
      local got = t:chunk(0)
      assert.are.same(t, got[1])
    end)

    it('returns tables of length 1 with chunk size 1', function()
    end)

    it('returns two chunks with chunk size of half the table size', function()
      local got = t:chunk(5)
      assert.are.same(5, #got[1])
      assert.are.same(#t - #got[1], #got[2])
      local whole = got[1]:merge(got[2])
      assert.are.same(t, whole)
    end)
  end)

  describe('unique', function()
    local t = _t{2, 3, 2, a=10, b=20, c=3, {a=80}, 10, 2}

    it('returns unique indexed values', function()
      local got = t:unique()
      assert.are.same(_t{2, 3, {a=80}, 10}, got)
    end)

    it('ignored non function fn', function()
      local got = t:unique('aa')
      assert.are.same(_t{2, 3, {a=80}, 10}, got)
    end)

    it('changes the value if function is provided', function()
      local got = t:unique(function(v)
        if v == 3 then
          return 666
        end
      end)
      assert.are.same(_t{2, 666, {a=80}, 10}, got)
    end)

  end)

  describe('sort', function()
    local t = _t{2, 3, 4, a=10, b=20, c=30}
    local original = vim.deepcopy(t)

    before_each(function()
      t = original
    end)

    it('returns new copy', function()
      local got = t:sort()
      table.insert(got, 10)
      assert.is_not.same(t, got)
    end)

    it('sorts by key', function()
      local got = t:sort(function(a, b) return a < b end)
      assert.are.same(_t{a=10, b=20, c=30, 2, 3, 4}, got)
    end)

    it('sorts by value', function()
      local got = t:sort(function(a, b) return a > b end)
      assert.are.same(_t{4, 3, 2, c=30, b=20, a=10}, got)
    end)
  end)

  describe('exec', function()
    local t = _t{2, 3, 4, a=10, b=20, c=30}

    it('errors if fn is not callable', function()
      assert.has.errors(function() t:exec() end)
      assert.has.errors(function() t:exec('aa') end)
    end)

    it('passes values to the given function', function()
      local got = t:exec(function(v)
        assert.are.same(v, t)
        return {987}
      end)
      assert.are.same(_t{987}, got)
    end)
  end)

  describe('when', function()
    local t = _t{2, 3, 4, a=10, b=20, c=30}

    it('returns the same table if the value is true', function()
      local got = t:when(true)
      assert.are.same(t, got)
    end)

    it('returns an empty table if the value is false', function()
      local got = t:when(false)
      assert.are.same(_t{}, got)
    end)
  end)

  describe('chaining methods', function()
    local t1 = _t{2, 3, 4, a=10, b=20, c=30}
    local t2 = _t{30, 11, 29}

    it('calling unique on sorted', function()
      local got = t1:sort():unique()
      assert.are.same(_t{2, 3, 4}, got)
    end)

    it('calling merge on sorted', function()
      local got = t1:sort():merge(t2)
      assert.are.same(_t{2, 3, 4, a=10, b=20, c=30, 30, 11, 29}, got)
    end)

    it('calling merge and then filter', function()
      local got = t1:merge(t2):filter(function(v)
        return v > 10
      end)
      assert.are.same(_t{b=20, c=30, 30, 11, 29}:sort(), got:sort())
    end)

    it('merge and map chaining', function()
      local got = t1:merge(t2):map(function(v)
        return v * 2
      end)
      assert.are.same(_t{4, 6, 8, a=20, b=40, c=60, 60, 22, 58}, got)
    end)

    it('returns empty after chaining and returning false from when', function()
      local got = t1:merge(t2):when(false):map(function(v)
        return v * 2
      end)
      assert.are.same(_t{}, got)
    end)
  end)
end)

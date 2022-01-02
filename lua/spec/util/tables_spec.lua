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

end)

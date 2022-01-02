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
end)

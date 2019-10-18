local animation = require 'cherry.libs.animation'

describe(
  '[animation]',
  function()
    it(
      '> rotateBackAndForth',
      function()
        local foo = display.newImage(App.display)
        assert.are.equal(foo.rotation, 0)

        foo.onCompleteCounts = 0
        animation.rotateBackAndForth(foo, 45, 200)
        assert.are.equal(foo.rotation, 45)

        foo.rotation = 0
        foo.onCompleteCounts = 1
        animation.rotateBackAndForth(foo, 45, 200)
        assert.are.equal(foo.rotation, 0)
      end
    )

    it(
      '> pop',
      function()
        local foo = display.newImage(App.display)
        foo.xScale = 0.11
        foo.yScale = 0.1

        animation.pop(foo, {delay = 200, time = 150})
        assert.are.equal(foo.xScale, 0.11)
        assert.are.equal(foo.yScale, 0.1)
      end
    )

    it(
      '> bounce one object',
      function()
        local foo = display.newImage(App.display)
        foo.xScale = 0
        foo.yScale = 0

        animation.bounce(foo)
        assert.are.equal(foo.xScale, 1)
        assert.are.equal(foo.yScale, 1)

        animation.bounce(foo, {scaleTo = 2})
        assert.are.equal(foo.xScale, 2)
        assert.are.equal(foo.yScale, 2)
      end
    )

    it(
      '> bounce many objects',
      function()
        local foo = display.newImage(App.display)
        local bar = display.newImage(App.display)
        foo.xScale = 0
        foo.yScale = 0
        bar.xScale = 0
        bar.yScale = 0

        animation.bounce({foo, bar})
        assert.are.equal(foo.xScale, 1)
        assert.are.equal(foo.yScale, 1)
        assert.are.equal(bar.xScale, 1)
        assert.are.equal(bar.yScale, 1)

        animation.bounce({foo, bar}, {scaleTo = 2})
        assert.are.equal(foo.xScale, 2)
        assert.are.equal(foo.yScale, 2)
        assert.are.equal(bar.xScale, 2)
        assert.are.equal(bar.yScale, 2)
      end
    )

    it(
      '> grow',
      function()
        local foo = display.newImage(App.display)
        local action =
          spy.new(
          function()
          end
        )

        animation.grow(
          foo,
          {
            fromScale = 0,
            time = 350,
            onComplete = action
          }
        )

        assert.are.equal(foo.xScale, 1)
        assert.are.equal(foo.yScale, 1)
        assert.spy(action).was.called(1)
      end
    )

    it(
      '> easeHide',
      function()
        local foo = display.newImage(App.display)
        local action =
          spy.new(
          function()
          end
        )

        animation.easeHide(foo, action)

        assert.are.equal(foo.xScale, 0.01)
        assert.are.equal(foo.yScale, 0.01)
        assert.spy(action).was.called(1)
      end
    )

    it(
      '> fadeIn',
      function()
        local foo = display.newImage(App.display)
        foo.alpha = 0

        animation.fadeIn(foo)

        assert.are.equal(foo.alpha, 1)
      end
    )
  end
)

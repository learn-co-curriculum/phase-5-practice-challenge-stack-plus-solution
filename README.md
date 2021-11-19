# Practice Challenge Solution: Stack Plus

Several possible approaches to this problem are provided below, along with their
complexity information.

## Solution 1

At first glance, this seems like a simple problem, and there *is* a simple
solution. Using an array as an underlying data structure, the `#push` and `#pop`
methods are easy to implement, and the `#increment` method just involves
iterating over `n` elements in the array and incrementing each of their values
by one:

```rb
class StackPlus
  attr_reader :data

  def initialize
    # Use an array as the underlying data structure
    @data = []
  end

  def push(value)
    # Push a value onto the array
    data.push(value)
  end

  def pop
    # Edge case: return -1 if the array is empty
    return -1 unless data.size > 0

    # Otherwise, just pop the top element from the array
    data.pop
  end

  def increment(n)
    # We need to iterate over n elements from the array,
    # but if there are fewer than n elements in the array,
    # we can just iterate over the length of the array
    [n, data.size].min.times do |i|
      # increment the value of each element by 1
      data[i] += 1
    end
  end
end
```

### Complexity

We have a O(n) space complexity, since we need to create an array to store each
element pushed on the stack.

We also have the following time complexity for each method:

- `#push`: O(1)
- `#pop`: O(1)
- `#increment`: O(n)

For the `#increment` method, the worst-case scenario is that we need to iterate
over every element in the array to increment its value, so we end up with a
linear runtime. Can we do better?

## Solution 2

Our goal with this second solution is to improve the time complexity of the
`#increment` method. That means that we need to find a way to increment each
value in the stack _without_ iterating over every element in the array when the
`#increment` method is called.

One very useful piece of information is that we only need to check the values of
the array _when the `#pop` method is called_. So we don't need to increment each
value in the `data` array when the `#increment` method is called, we just need a
way to _keep track of all the `#increment` operations_. We can then apply the
correct incremented value when the `#pop` method is called.

To do this, we'll make a second array `inc` that will have the same number of
elements as the `data` array. The `inc` array will keep track of the **number of
elements that need to be incremented** by storing a value at the index position
that corresponds to that number; the **value** stored will indicate the number
of times those elements should be incremented. When the `#pop` method is called,
the element will be incremented as indicated by the corresponding element in the
`inc` array; in addition, if there are any remaining elements in the stack, the
increment information will be passed down to the next element in the `inc` array
so that those remaining elements also get incremented when they are popped off
the stack.

The process is probably easier to visualize with some diagrams:

![Stack Plus Solution](https://curriculum-content.s3.amazonaws.com/phase-5/phase-5-practice-challenge-stack-plus/stack-plus-solution.png)

Before we start popping elements from the stack, our two arrays look like this:

- `data`: `[2, 3, 5]`
- `inc`: `[0, 1, 0]`

The `inc` array above tells us that the first two elements of the `data` array
each need to be incremented by 1 when they are popped from the stack.

When `#pop` is called, we pop the top elements from _both_ the `data` and `inc`
arrays, add them together to get 5, and return that value. Then the arrays look
like this:

- `data`: `[2, 3]`
- `inc`: `[0, 1]`

Calling `#pop` again, we pop `data` and `inc`, add them together to get 4, and
return that value. But we **also** need to update the top of the `inc` array to
keep track of the fact that the final value, 2, also needs to be incremented:

- `data`: `[2]`
- `inc`: `[1]`

Here's what this looks like in code:

```rb
class StackPlus
  attr_reader :inc, :data

  def initialize
    # initialize two arrays, one to encode the incrementing data
    @inc = []
    @data = []
  end

  def push(value)
    # we need to ensure that the `inc` array always has the same number of elements
    # as the `data` array, so any time a new element is pushed to the stack,
    # add 0 at the top of the `inc` array
    data.push(value)
    inc.push(0)
  end

  def pop
    return -1 unless data.size > 0

    # pop the top value from the `inc` array
    inc_val = inc.pop

    # we need to keep the top value of the `inc` array updated with the
    # information needed to increment the remaining values of the `data`
    # array, so whatever the top element of the `inc` array is should be updated
    inc[inc.size - 1] += inc_val if inc.size > 0

    # finally, pop the top element of the data array, and return the incremented value
    data.pop + inc_val
  end

  def increment(n)
    # since `n` may be greater than the size of our stack, we can get the correct index by
    # finding the minimum of `n` and the size of the stack
    i = [n, inc.size].min - 1

    # here, we encode the value we need to increment at the correct position in the `inc` array
    inc[i] += 1 if inc[i]
  end
end
```

This solution is not an easy one to figure out, so don't stress if you didn't
come up with it! Try to make sure you understand the steps to implement this
solution, then see if you can reproduce it on your own for practice. It's useful
to see solutions like this to help in case you encounter similar problems in the
future.

### Complexity

Since we have two arrays — one for the data, and one for the incrementing
information — the space complexity is worse than our first solution, but it
still simplifies to O(n).

We also have the following time complexity for each method:

- `#push`: O(1)
- `#pop`: O(1)
- `#increment`: O(1)

As you can see, we were able to improve `#increment` to a constant time
operation, since we don't need to iterate over each element in the array.
Instead, we just look up one element in the `inc` array and update its value.

## Solution 3

Here's a slight variation on Solution 2 that involves storing the value and the
increment data together in the same array. If you understood the approach to
Solution 2, this should feel similar. The key change here is that there is only
one array, `data`, and each element in that array is an array of two elements:
the value, and the increment data.

Using our example from Solution 2:

```rb
stack = StackPlus.new
stack.push(2) # data is: [[2, 0]]
stack.push(3) # data is: [[2, 0], [3, 0]]
stack.increment(2) # data is: [[2, 0], [3, 1]]
stack.increment(5) # data is: [[2, 0], [3, 1], [5, 0]]
stack.pop # return 5 + 0, data is: [[2, 0], [3, 1]]
stack.pop # return 3 + 1, data is: [[2, 1]]
stack.pop # return 2 + 1, data is: []
```

Here's how this solution works:

```rb
class StackPlus
  attr_reader :data

  def initialize
    @data = []
  end

  def push(value)
    # store two values in the data array: the value itself, and the information
    # about how that value should be incremented
    data.push([value, 0])
  end

  def pop
    return -1 unless data.size > 0

    # each element in the `data` array is now an array of two elements [value, increment]
    value, inc = data.pop

    # we need to update the top element of the data array to have the correct information on incrementing
    data[data.size - 1][1] += inc if data.size > 0

    # return the incremented value
    value + inc
  end

  def increment(n)
    # find the element that needs to store the information about
    # how to increment the elements below
    i = [n, data.size].min - 1

    # since each element in the `data` array is now an array of two elements [value, increment]
    # we need to update the increment element at the correct position in the data array
    data[i][1] += 1 if data[i]
  end
end
```

### Complexity

We end up with the same space complexity as Solution 2, since we still need the
same amount of space to encode our two-dimensional `data` array as we did for
two separate `inc` and `data` arrays.

Our time complexity remains the same as well, since we're performing basically
the same operations in `push`, `pop`, and `increment`.

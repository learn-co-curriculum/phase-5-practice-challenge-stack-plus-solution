class StackPlus
  attr_reader :data

  def initialize
    @data = []
  end

  def push(value)
    data.push([value, 0])
  end

  def pop
    return -1 unless data.size > 0

    value, inc = data.pop

    data[data.size - 1][1] += inc if data.size > 0

    value + inc
  end

  def increment(n)
    i = [n, data.size].min - 1
    data[i][1] += 1 if data[i]
  end
end

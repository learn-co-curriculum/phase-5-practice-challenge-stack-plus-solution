describe StackPlus do
  let(:stack) { StackPlus.new }

  describe '#pop' do
    it 'returns -1 when the stack is empty' do
      expect(stack.pop).to eq(-1)
    end

    it 'returns the top of the stack after the push method has been called' do
      stack.push(3)
      expect(stack.pop).to eq(3)
    end

    it 'returns the top of the stack after the push method has been called multiple times' do
      stack.push(3)
      stack.push(4)
      expect(stack.pop).to eq(4)
    end

    it 'returns the top of the stack after the increment method has been called' do
      stack.push(3)              # [3]
      stack.push(4)              # [3, 4]
      stack.increment(2)         # [4, 5]
      expect(stack.pop).to eq(5) # [4]
      expect(stack.pop).to eq(4) # []
    end

    it 'passes test case 1' do
      stack.push(7)              # [7]
      expect(stack.pop).to eq(7) # []
      stack.push(4)              # [4]
      stack.push(1)              # [4, 1]
      stack.push(2)              # [4, 1, 2]
      stack.increment(3)         # [5, 2, 3]
      expect(stack.pop).to eq(3) # [5, 2]
      stack.push(3)              # [5, 2, 3]
      stack.increment(2)         # [6, 3, 3]
      stack.push(4)              # [6, 3, 3, 4]
      expect(stack.pop).to eq(4) # [6, 3, 3]
      expect(stack.pop).to eq(3) # [6, 3]
      expect(stack.pop).to eq(3) # [6]
      expect(stack.pop).to eq(6) # []
    end

    it 'passes test case 2' do
      stack.push(1)               # [1]
      stack.push(2)               # [1, 2]
      expect(stack.pop).to eq(2)  # [1]
      stack.push(2)               # [1, 2]
      stack.push(3)               # [1, 2, 3]
      stack.increment(5)          # [2, 3, 4]
      stack.increment(2)          # [3, 4, 4]
      expect(stack.pop).to eq(4)  # [3, 4]
      expect(stack.pop).to eq(4)  # [3]
      expect(stack.pop).to eq(3)  # []
      expect(stack.pop).to eq(-1) # []
    end
  end
end

require 'spec_helper'
require 'block'

RSpec.describe Block do
  subject(:line){ Block.new(:line, [0, 0]) }
  
  describe "#rotate" do
    it "should rotate the block left" do
      rotated = line.rotate(line.spaces_occupied, -1)
      expect(rotated).to eq([[3, 0], [3, 1], [3, 2], [3, 3]])
    end
    
    it "should rotate the block right" do
      rotated = line.rotate(line.spaces_occupied, 1)
      expect(rotated).to eq([[0, 3], [0, 2], [0, 1], [0, 0]])
    end
  end
  
end 
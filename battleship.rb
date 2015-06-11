# Battleship!

# https://gist.github.com/chrissrogers/f155311ab11cedf13a0e

require 'rspec/autorun'

class Battleship
  def initialize(ships)
    @board = {}
    @alphabet = ("A".."Z").to_a

    ships.each do |ship|
      position = ship[:position]
      direction = ship[:direction]
      length = ship[:length]

      set_position(position, direction, (length - 1))
    end
  end

  def set_position(position, direction, length)
    @board[position] = true

    if length > 0
      alpha_position = position[0]
      numeric_position = position[1]

      case direction
        when :north
          alpha_position = @alphabet.index(alpha_position) - 1
        when :south
          alpha_position = @alphabet.index(alpha_position) + 1
        when :east
          numeric_position += 1
        when :west
          numeric_position -= 1
      end

      new_position = @alphabet[alpha_position] + numeric_position
      set_position(new_position, direction, (length - 1))
    end
  end

  def fire!(position)
    if @board[position]
      true
    else
      false
    end
  end
end

describe Battleship do
  let(:carrier) do
    {
      type: :carrier,
      position: 'A6',
      direction: :south,
      length: 5
    }
  end

  let(:battleship) do
    {
      type: :battleship,
      position: 'D9',
      direction: :south,
      length: 4
    }
  end

  let(:submarine) do
    {
      type: :submarine,
      position: 'I7',
      direction: :north,
      length: 3
    }
  end

  let(:game) { Battleship.new([carrier, battleship, submarine]) }

  subject { game }

  context 'hits' do
    it 'the beginning edge of the Submarine' do
      turn = subject.fire!('I7') # Hits the Submarine

      expect(turn).to be true
    end

    it 'the middle of the Battleship' do
      turn = subject.fire!('G9') # Hits the Battleship

      expect(turn).to be true
    end

    it 'the ending edge of the Carrier' do
      turn = subject.fire!('E6') # Hits the Carrier

      expect(turn).to be true
    end
  end

  context 'misses' do
    it 'and hits the middle of the ocean' do
      turn = subject.fire!('E3')

      expect(turn).to be false
    end
  end
end

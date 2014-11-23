require_relative 'runner.rb'

describe 'Sudoku' do
  let(:game) {Sudoku.new("29-5----77-----4----4738-129-2--3-648---5--7-5---672--3-9--4--5----8-7---87--51-9") }

  it 'should return a string of 81 character' do
    expect(game.board.length).to eq(81)
  end

  it 'should return a string of 81 characters' do
    # expect(game.solve).should_not include("-")
    game.solve
    expect(game.board).to match(/[1-9]{81}/)
  end

  it 'should return a string of 9 lines' do
    expect(game.to_s).to match(/^([1-9-] ){9}${9}/)
  end

end

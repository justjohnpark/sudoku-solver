require_relative "cell.rb"

class Sudoku
  def initialize(board_string)
    flat_board = Array.new(81) { Cell.new(board_string.slice!(0,1))}
    @game_board = Array.new(9) { flat_board.slice!(0, 9) }
  end

  def solve
    until is_solved?
      (0..8).each do |row|
        (0..8).each {|col| consider_cell_neighbors(row, col)}
      end
      consider_rows
      consider_cols

      (0..8).each do |row|
        (0..8).each { |col| solve_cell(row, col) }
      end
    end
    self.board
  end

  def board
    string = ''
    @game_board.each do |row|
      row.each { |cell| string << cell.to_s }
    end
    string
  end

  def to_s
    string = ""
    @game_board.each do |row|
      row.each { |cell| string << cell.to_s + " "}
      string << "\n"
    end
    string
  end

  def is_correct?
    @game_board.each { |row| return false unless unique_digits?(row) }
    (0..8).each { |col| return false unless unique_digits?(get_col(col)) }
    return true
  end

    private

  def consider_cell_neighbors(row, col)
    return if @game_board[row][col].to_s != "-"
    neighbors = get_neighbors(row, col)
    neighbors.each do |neighbor|
      @game_board[row][col].eliminate(neighbor.to_s)
    end
  end

  def solve_cell(row, col, solution=nil)
    cell = get_cell(row, col)
    return if cell.solution != "-"

    if solution == nil
      return if cell.possibilities.size > 1
    end

    cell.set(solution)
    neighbors = get_neighbors(row, col)
    neighbors.each { |neighbor| neighbor.eliminate(solution) }
  end

  def get_neighbors(row, col)
    neighbors = Array.new
    neighbors += get_row(row)
    neighbors += get_col(col)
    neighbors += get_box(row, col)
  end

  def get_row(row)
    @game_board[row]
  end

  def get_col(col)
    @game_board.collect { |row| row[col] }
  end

  def get_box(row, col)
    row = get_box_start(row)
    col = get_box_start(col)
    box = Array.new
    (row..row+2).each do |i|
      (col..col+2).each { |j| box << @game_board[i][j] }
    end
    box
  end

  def get_box_start(index)
    (index / 3) * 3
  end

  def get_cell(row, col)
    @game_board[row][col]
  end

  def is_solved?
    return !(self.board.include? "-")
  end

  def consider_rows
    @game_board.each_with_index do |row, row_idx|
      ('1'..'9').each do |num|
        matches = Array.new
        row.each_index do |col_idx|
          if row[col_idx].possibilities.include? num
            matches << col_idx
          end
        end
        if matches.size == 1
          solve_cell(row_idx, matches[0], num)
        end
      end
    end
  end

  def consider_cols
    (0..8).each do |col_idx|
      col = get_col(col_idx)
      ('1'..'9').each do |num|
        matches = []
        col.each_index do |row_idx|
          if col[row_idx].possibilities.include? num
            matches << row_idx
          end
        end

        if matches.size == 1
          solve_cell(matches[0], col_idx, num)
        end
      end
    end
  end

end

  # def correct_digits?(array)
  #   digits = []
  #   array.each { |cell| digits << cell.to_s }
  #   return digits.sort! == ('1'..'9').to_a
  # end

  # def unique_digits?(array)
  #   array.uniq.length == 9
  # end


  # def correct_digits?(array)
  #   array.reduce(:+) == 45
  # end

  # def educated_guess(index)
  #   if get_each_cell.to_s == '-'
  #     get_each_cell.set(get_each_cell.possibilities[0])



  # end

  # def get_each_cell
  #   (0..8).each do |row|
  #     (0..8).each do |col|
  #         @game_board[row][col]
  #     end
  #   end
  # end
  # def guessing_time

  #   (0..8).each do |row|
  #     (0..8).each do |col|
  #       if @game_board[row][col].to_s == '-'
  #         @game_board[row][col].possibilities.each do |x|
  #           @game_board[row][col] = x
  #           neighbors = get_neighbors(row, col)



  #           if @game_board[row][col].solved?

  #           end
  #         end
  #       end
  #     end
  #   end

  # end

test = Sudoku.new("1-58-2----9--764-52--4--819-19--73-6762-83-9-----61-5---76---3-43--2-5-16--3-89--")
# test = Sudoku.new("--5-3--819-285--6-6----4-5---74-283-34976---5--83--49-15--87--2-9----6---26-495-3")
# test = Sudoku.new("29-5----77-----4----4738-129-2--3-648---5--7-5---672--3-9--4--5----8-7---87--51-9")
# test = Sudoku.new("-8--2-----4-5--32--2-3-9-466---9---4---64-5-1134-5-7--36---4--24-723-6-----7--45-")
# test = Sudoku.new("6-873----2-----46-----6482--8---57-19--618--4-31----8-86-2---39-5----1--1--4562--")
# test = Sudoku.new("---6891--8------2915------84-3----5-2----5----9-24-8-1-847--91-5------6--6-41----")
# test = Sudoku.new("-3-5--8-45-42---1---8--9---79-8-61-3-----54---5------78-----7-2---7-46--61-3--5--")
# test = Sudoku.new("-96-4---11---6---45-481-39---795--43-3--8----4-5-23-18-1-63--59-59-7-83---359---7")
# test = Sudoku.new("----754----------8-8-19----3----1-6--------34----6817-2-4---6-39------2-53-2-----")
# test = Sudoku.new("3---------5-7-3--8----28-7-7------43-----------39-41-54--3--8--1---4----968---2--")
# test = Sudoku.new("3-26-9--55--73----------9-----94----------1-9----57-6---85----6--------3-19-82-4-")
# test = Sudoku.new("-2-5----48-5--------48-9-2------5-73-9-----6-25-9------3-6-18--------4-71----4-9-")
# test = Sudoku.new("--7--8------2---6-65--79----7----3-5-83---67-2-1----8----71--38-2---5------4--2--")
# test = Sudoku.new("----------2-65-------18--4--9----6-4-3---57-------------------73------9----------")
# test = Sudoku.new("---------------------------------------------------------------------------------")

test.solve
# puts test.to_s
# puts test.is_correct?
# test.to_s

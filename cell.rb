class Cell
  attr_reader :solution, :possibilities

  def initialize (string)
    if string == "-"
      @possibilities = ("1".."9").to_a
      @solution = "-"
    else
      @possibilities = Array.new
      @solution = string
    end
  end

  def solved?
    @possibilities.size <= 1
  end

  def eliminate(number)
    @possibilities.delete(number)
  end

  def set(number)
    return if number == nil
    return if @solution != "-"
    @possibilities = [] unless number == "-"
    @solution = number
  end

  def to_s
    return @solution
  end

end

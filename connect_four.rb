class Board
    attr_accessor :grid, :rows, :columns

    def initialize(rows = 6, columns = 7)
        @rows = rows
        @columns = columns
        @grid = Array.new(rows) { Array.new(columns, ' ') }
    end

    def display_board
        @grid.each do |row|
            puts row.join(' | ')
        end

        puts '-----------------------------'
        puts (1..@columns).to_a.join('   ')
    end

    def drop_disc(column, symbol)
        return false unless valid_move?(column)

        row = @rows - 1

        while row >= 0
            break if @grid[row][column - 1] == ' '
            row -= 1
        end

        @grid[row][column - 1] = symbol
        true
    end

    def valid_move?(column)
        column.between?(1, @columns) && @grid[0][column - 1] == ' '
    end

    def win?(symbol)
        directions = [[0, 1], [1, 0], [1, 1], [-1, 1]]

        @grid.each_with_index do |row, i|
            row.each_with_index do |cell, j|
                next unless cell == symbol

                directions.each do |dir|
                    count = 1
                    x, y = dir

                    while count < 4
                        next_i = i + (x * count)
                        next_j = j + (y * count)

                        break if next_i < 0 || next_i >= @rows || next_j < 0 || next_j >= @columns || @grid[next_i][next_j] != symbol

                        count += 1
                    end

                    return true if count == 4
                end
            end
        end

        false
    end

    def full?
        @grid[0].none?(' ')
    end
end

class Player
    attr_reader :name, :symbol

    def initialize(name, symbol)
        @name = name
        @symbol = symbol
    end

    def make_move
        print "#{name}, choose a column (1-7): "
        gets.chomp.to_i
    end
end

class Game
    def initialize
        @board = Board.new
        @player1 = Player.new('Player 1', 'X')
        @player2 = Player.new('Player 2', 'O')
        @current_player = @player1
    end

    def start_game
        loop do
            @board.display_board
            column = @current_player.make_move

            until @board.drop_disc(column, @current_player.symbol)
                puts "Invalid move! Choose another column."
                column = @current_player.make_move
            end

            if @board.win?(@current_player.symbol)
                @board.display_board
                puts "#{@current_player.name} wins!"
                break
            elsif @board.full?
                @board.display_board
                puts "It's a tie!"
                break
            end

            switch_players
        end
    end

    private

    def switch_players
        @current_player = (@current_player == @player1) ? @player2 : @player1
    end
end

game = Game.new
game.start_game
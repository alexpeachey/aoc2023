module AOC
  class Day02b < Day02
    def sum_powers
      parse_games
      @games.map(&method(:calculate_power)).sum
    end

    private

    def calculate_power(_id, game)
      game[:maxes][:red] * game[:maxes][:green] * game[:maxes][:blue]
    end
  end
end

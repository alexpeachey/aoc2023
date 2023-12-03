module AOC
  class Day02a < Day02
    @@bag_contents = {red: 12, green: 13, blue: 14}

    def determine_legal_games()
      parse_games
      @games.select(&method(:legal_game?))
        .to_h
        .keys
        .sum
    end

    private

    def legal_game?(_id, game)
      game[:pulls].all?(&method(:legal_pull?))
    end

    def legal_pull?(pull)
      pull.all? {|color, count| count <= @@bag_contents[color]}
    end
  end
end

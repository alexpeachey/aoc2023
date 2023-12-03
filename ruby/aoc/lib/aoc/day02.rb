module AOC
  class Day02 < Day
    def parse_games()
      @games ||= File.readlines(@path, chomp: true)
        .map(&method(:parse_game))
        .to_h
    end

    private

    def parse_game(line)
      game_reference, raw_game = line.split(": ")
      _, id = game_reference.split(" ")
      pulls = parse_pulls(raw_game)
      [id.to_i, {pulls: pulls, maxes: find_maxes(pulls)}]
    end

    def parse_pulls(raw_game)
      raw_game.split("; ")
        .map(&method(:parse_pull))
    end

    def parse_pull(raw_pull)
      raw_pull.split(", ")
        .map(&method(:parse_color))
        .to_h
    end

    def parse_color(raw_color)
      count, color = raw_color.split(" ")
      [color.to_sym, count.to_i]
    end

    def find_maxes(pulls)
      pulls.reduce({red: 0, green: 0, blue: 0}, &method(:update_maxes))
    end

    def update_maxes(maxes, pull)
      maxes.map {|color, max| [color, [max, pull.fetch(color, 0)].max]}
        .to_h
    end
  end
end

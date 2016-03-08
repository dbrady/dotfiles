# stupid helpers for Township
require 'colorize'
require 'ostruct'

module Township
  # The Market offers bundles of items, usually at a profit, but not always at
  # the same profit amount. Given the cost of the good in question and the
  # offers (as an array of pairs: number of items and offer price)
  #
  # E.g. Say the steward at the market is offering sweaters:
  # 2 for $134
  # 6 for $404
  # 7 for $498
  #
  # market_profit 76, [[2,134],[6,404],[7,498]]
  # =>
  #
  # 2x76=152 for 134 => 18 profit
  # 6x76=456 for 404 => 52 profit
  # 7x76=532 for 498 => 34 profit

  def market_profit(value, counts_and_prices)
    details = counts_and_prices.map do |count,price|
      [
        count,
        value,
        count * value,
        price,
        count * value - price,
        false
      ]
    end

    best_profit = details.max_by {|d| d[4] }
    best_profit[5] = true

    details.each do |count, value, total_value, price, profit, best|
      str = "%2d x $%4d = $%4d for $%4d => $%4d profit %-20s" % [
        count, value, total_value, price, profit,
        best ? "<<< BEST PROFIT" : ""
      ]

      str = best ? str.green : str.red
      puts str
    end
  end

  GOODS_TYPES = %i(crop farm bakery feed dairy sugar textile tailor snack fast_food
  paper ice_cream jam pastry rubber plastic candy mexican_food furniture shoes
  jewelry asian_food grill perfume beverage foundry mine ships)

  class Goods
    attr_accessor :name, :type, :level, :time, :cost, :value, :xp
    def initialize name, type, level, time, cost, value, xp
      @name, @type, @level, @time, @cost, @value, @xp = name, type, level, time,
      cost, value, xp
    end

    # # should this be in a database? Hmm...
    # {
    #   wheat: Goods.new(:wheat, :crop, 1, 120, 0, 1, 1),
    #   corn:  Goods.new(:corn, :crop,  2, 300, 1, 3, 3), # etc
    # }


  end

  # DBWT - Development By Wishful Thinking
  # Given a list of what production facilities I have, what goods I need and
  # what goods I already have on hand, generate the build chart. Order the build
  # chart by what orders I can fill the fastest, but also stagger things so that
  # the maximum use of time is made, e.g. if one order needs 6 cotton and
  # another needs 4, plant 10 cotton at once if that results in the fastest
  # overall build.
  def production_chart(production, needs, haves)
  end
end

include Township

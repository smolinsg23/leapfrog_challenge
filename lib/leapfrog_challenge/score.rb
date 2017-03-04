module LeapfrogChallenge
  class Score
    attr_accessor :propensity, :ranking

    def initialize(propensity, ranking)
      @propensity = propensity
      @ranking = ranking
    end

    def self.new_from_request(attributes)
      self.new(attributes[:propensity], attributes[:ranking])
    end
  end
end 
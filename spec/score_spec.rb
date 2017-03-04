require "spec_helper"

describe LeapfrogChallenge::Score do
  it "can create an instance" do
    score = LeapfrogChallenge::Score.new(0.0626, "C")
    expect(score.propensity).to eq(0.0626)
    expect(score.ranking).to eq("C")
  end

  it "can create from a response hash" do
    score = LeapfrogChallenge::Score.new_from_request(propensity: 0.323, ranking: "B")
    expect(score).to be_a LeapfrogChallenge::Score
  end
end
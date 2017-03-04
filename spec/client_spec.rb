require "spec_helper"

describe LeapfrogChallenge::Client do
  let(:client) { LeapfrogChallenge::Client.new }

  describe "#initialize" do 
    it "creates a client object with default url" do
      expect(client.url).to eq(LeapfrogChallenge::Client::BASE_URL)
    end

    it "can Accept a custom url" do
      custom_client = LeapfrogChallenge::Client.new("http://custom.com")
      expect(custom_client.url).to eq("http://custom.com")
    end
  end

  context "#make_request" do
    describe "valid request" do
      before(:all) do
        test_url = "#{LeapfrogChallenge::Client::BASE_URL}?age=35&income=50000&zipcode=60621"
        stub_request(:get, test_url).
           with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Host'=>'not_real.com', 'User-Agent'=>'rest-client/2.0.1 (darwin16.0.0 x86_64) ruby/2.3.1p112'}).
           to_return(:status => 200, :body => '{"propensity": 0.26532,"ranking": "C"}', :headers => {})

         @result = LeapfrogChallenge::Client.new.make_request(50000, 60621, 35)
      end
      
      it "should return a Score object" do
        expect(@result).to be_a LeapfrogChallenge::Score
      end

      it "should return the right values" do
        expect(@result.propensity).to eq(0.26532)
      end
    end

    describe "Bad Request" do
      before(:all) do
        test_url = "#{LeapfrogChallenge::Client::BASE_URL}?age=35&income=50000&zipcode=60621"
        stub_request(:get, test_url).
           with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Host'=>'not_real.com', 'User-Agent'=>'rest-client/2.0.1 (darwin16.0.0 x86_64) ruby/2.3.1p112'}).
           to_return(:status => 400, :body => '{"error": "Bad request"}', :headers => {})

         @result = LeapfrogChallenge::Client.new.make_request(50000, 60621, 35)
       end

       it "should handle a request with bad parameters" do
          expect(@result[:error]).to eq("Bad request")
          expect(@result[:status]).to eq(400)
       end
    end

    describe "Server Error" do
      before(:all) do
        test_url = "#{LeapfrogChallenge::Client::BASE_URL}?age=35&income=50000&zipcode=60621"
        stub_request(:get, test_url).
           with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Host'=>'not_real.com', 'User-Agent'=>'rest-client/2.0.1 (darwin16.0.0 x86_64) ruby/2.3.1p112'}).
           to_return(:status => 500, :body => '{"error": "Internal server error"}', :headers => {})

         @result = LeapfrogChallenge::Client.new.make_request(50000, 60621, 35)
       end

       it "should handle a request with bad parameters" do
          expect(@result[:status]).to eq(500)
          expect(@result[:error]).to eq("Internal server error")
       end
    end

    describe "when timed out" do
      before(:all) do
        test_url = "#{LeapfrogChallenge::Client::BASE_URL}?age=35&income=50000&zipcode=60621"
        stub_request(:get, test_url).
           with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Host'=>'not_real.com', 'User-Agent'=>'rest-client/2.0.1 (darwin16.0.0 x86_64) ruby/2.3.1p112'}).
        to_timeout
        @result = LeapfrogChallenge::Client.new.make_request(50000, 60621, 35)
      end

      it "should rescue Timeout exception" do
        expect(@result[:error]).to eq("Server timeout")
      end
    end
  end
end

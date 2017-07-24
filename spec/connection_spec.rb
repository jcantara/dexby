require 'dexby/connection'
require 'json'

RSpec.describe Dexby::Connection do

  let(:subject) { described_class }

  describe "class methods" do
    describe ".login_body" do
      it "creates login request body" do
        expect( subject.login_body('user', 'pass') ).to eq ({'applicationId' => "d8665ade-9673-4e27-9ff6-92db4ce13d13", "accountName" => 'user', "password" => 'pass'})
      end
    end

    describe ".read_query" do
      it "creates read query" do
        expect( subject.read_query('banana', 5, 6) ).to eq ({"sessionId" => 'banana', "minutes" => 5, "maxCount" => 6})
      end
    end

    context "methods that make requests" do
      let(:fake_response) { double('response') }
      before(:example) do
        allow(fake_response).to receive(:body).and_return('"blah"')
        allow(fake_response).to receive(:code).and_return 200
      end

      describe ".login" do
        it "posts to login endpoint" do
          expect(subject).to receive(:post).with(subject::LOGIN_ENDPOINT, body: subject.login_body('user', 'pass').to_json).and_return(fake_response)
          subject.login('user', 'pass')
        end
        it "returns session_id and response code" do
          expect(fake_response).to receive(:body).and_return('"blah"')
          allow(subject).to receive(:post).with(subject::LOGIN_ENDPOINT, body: subject.login_body('user', 'pass').to_json).and_return(fake_response)
          expect(subject.login('user', 'pass')).to eq ["blah", 200]
        end
      end

      describe ".read" do
        let(:parsed_response) { [{"DT"=>"/Date(1500679432000-0700)/", "ST"=>"/Date(1500668632000)/", "Trend"=>3, "Value"=>263, "WT"=>"/Date(1500668632000)/"}] }

        it "posts to read endpoint" do
          allow(fake_response).to receive(:parsed_response).and_return parsed_response
          expect(subject).to receive(:post).with(subject::READ_ENDPOINT, query: subject.read_query('banana', 5, 6)).and_return(fake_response)
          subject.read('banana', 5, 6)
        end
        it "returns parsed_response and response code" do
          expect(fake_response).to receive(:parsed_response).and_return parsed_response
          expect(subject).to receive(:post).with(subject::READ_ENDPOINT, query: subject.read_query('banana', 5, 6)).and_return(fake_response)
          expect(subject.read('banana', 5, 6)).to eq [parsed_response, 200]
        end
      end
    end
  end

end

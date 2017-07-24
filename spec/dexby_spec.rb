require 'dexby'

RSpec.describe Dexby do
  describe "#new" do
    context "without user/pass arguments" do
      it "raises an error" do
        expect { described_class.new }.to raise_error ArgumentError
      end
    end
    context "with user/pass arguments" do
      let(:default_args) { {username: 'test', password: 'test'} }
      it "returns a Dexby::Reader" do
        expect(described_class.new(*default_args)).to be_a Dexby::Reader
      end
    end
  end
end

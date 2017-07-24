require 'dexby/parse'
require 'date'

RSpec.describe Dexby::Parse do

  describe ".parse" do
    context "when given a response object from dexcom api" do
      let(:response_object) { {"DT"=>"/Date(1500828526000-0700)/", "ST"=>"/Date(1500817726000)/", "Trend"=>4, "Value"=>84, "WT"=>"/Date(1500817726000)/"} } 
      let(:parsed_response) { {trend: :steady, date: DateTime.new(2017,7,23,9,48,46,Rational(-7,24)), value: 84} }

      it "returns a ruby hash representation of the response" do
        expect(described_class.parse(response_object)).to eq parsed_response
      end
    end
    context "when given a different response object from dexcom api" do
      let(:response_object) { {"DT"=>"/Date(1500828525000-0700)/", "ST"=>"/Date(1500817726000)/", "Trend"=>5, "Value"=>85, "WT"=>"/Date(1500817726000)/"} } 
      let(:parsed_response) { {trend: :falling_slightly, date: DateTime.new(2017,7,23,9,48,45,Rational(-7,24)), value: 85} }

      it "returns a ruby hash representation of the response" do
        expect(described_class.parse(response_object)).to eq parsed_response
      end
    end
  end

  describe ".parse_trend" do
    let(:trend_map) { {0=>:"", 1=>:rising_quickly, 2=>:rising, 3=>:rising_slightly, 4=>:steady, 5=>:falling_slightly, 6=>:falling, 7=>:falling_quickly, 8=>:unknown, 9=>:unavailable} }

    context "given a valid trend" do
      it "returns the expected trend symbol for all keys" do
        trend_map.each do |k, v|
          expect(described_class.parse_trend(k)).to eq v
        end
      end
      it "returns the expected trend symbol for key 1" do
        expect(described_class.parse_trend(1)).to eq :rising_quickly
      end
    end

    context "given an invalid trend" do
      it "raises an exception" do
        expect { described_class.parse_trend("banana") }.to raise_error ArgumentError
      end
    end
  end

  describe ".parse_date" do
    let(:unparsed_date) { "/Date(1500828525000-0700)/" }

    context "given a valid date" do
      it "returns a DateTime" do
        expect(described_class.parse_date(unparsed_date)).to be_a DateTime
      end
      it "returns the correct date" do
        expect(described_class.parse_date(unparsed_date).new_offset("+0000").iso8601(0)).to eq "2017-07-23T16:48:45+00:00"
      end
      it "converts to the local timezone" do
        expect(described_class.parse_date(unparsed_date).offset).to eq DateTime.now.offset
      end
    end
    context "given an invalid date" do
      it "raises an error" do
        expect { described_class.parse_date("ajsfjasjdf") }.to raise_error ArgumentError
      end
    end
  end

  describe ".parse_all" do
    context "when given an array of responses" do
      let(:response) { [{"DT"=>"/Date(1500828526000-0700)/", "ST"=>"/Date(1500817726000)/", "Trend"=>4, "Value"=>84, "WT"=>"/Date(1500817726000)/"}] * 3 } 
      let(:parsed) { [{trend: :steady, date: DateTime.new(2017,7,23,9,48,46,Rational(-7,24)), value: 84}] * 3 }

      it "returns an array" do
        expect(described_class.parse_all(response)).to be_a Array
      end
      it "parses every element" do
        expect(described_class.parse_all(response)).to eq parsed
      end
    end
  end

end

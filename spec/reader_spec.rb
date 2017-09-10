require 'dexby/reader'
require 'dexby/connection'
require 'dexby/parse'

RSpec.describe Dexby::Reader do
  let(:fake_connection_class) { class_double(Dexby::Connection) }
  let(:fake_parser_class) { class_double(Dexby::Parse) }
  let(:default_args) { ['user', 'pass', fake_connection_class, fake_parser_class] }
  let(:subject) { described_class.new(*default_args) }

  describe "class methods" do
    describe ".new" do
      context "without required user/pass" do
        it "raises an error" do
          expect { described_class.new }.to raise_error ArgumentError
        end
      end
      context "with required user/pass" do
        it "returns a Dexby::Reader" do
          expect(described_class.new(*default_args)).to be_a Dexby::Reader
        end
        it "saves user/password" do
          expect(subject.instance_variable_get(:@username)).to eq 'user'
          expect(subject.instance_variable_get(:@password)).to eq 'pass'
        end
        it "has a nil session_id" do
          expect(subject.instance_variable_get(:@session_id)).to be_nil
        end
        context "dependency injection" do
          it "sets default dependencies" do
            subject = described_class.new('user', 'pass')
            expect(subject.instance_variable_get(:@connection_class)).to be Dexby::Connection
            expect(subject.instance_variable_get(:@parser_class)).to be Dexby::Parse
          end
          it "sets overridden dependencies" do
            expect(subject.instance_variable_get(:@connection_class)).to be fake_connection_class
            expect(subject.instance_variable_get(:@parser_class)).to be fake_parser_class
          end
        end
      end
    end
  end
  
  describe "instance methods" do
    describe "#connection" do
      it "returns connection class" do
        expect(subject.connection).to be fake_connection_class
      end
    end

    describe "#parser" do
      it "returns parser class" do
        expect(subject.parser).to be fake_parser_class
      end
    end

    describe "#read" do
      context "arguments" do
        before(:example) do
          allow(fake_connection_class).to receive(:login).and_return(['banana', 200])
          allow(fake_parser_class).to receive(:parse_all).and_return([])
        end
        it "accepts optional minutes and count arguments" do
          expect(fake_connection_class).to receive(:read).with('banana', 23,24).and_return([[],200])
          subject.read(23,24)
        end
        it "has default minutes and count arguments" do
          expect(fake_connection_class).to receive(:read).with('banana', 1440, 1).and_return([[],200])
          subject.read
        end
      end
      context "without an existing session_id" do
        before(:example) do
          allow(fake_connection_class).to receive(:read).and_return([[],200])
          allow(fake_parser_class).to receive(:parse_all).and_return([])
        end
        context "where login is successful" do
          it "logs in and saves session_id" do
            expect(fake_connection_class).to receive(:login).and_return(['banana', 200])
            subject.read
            expect(subject.instance_variable_get(:@session_id)).to eq 'banana'
          end
        end
        context "where login fails" do
          [500, 401, 302].each do |code|
            it "raises exception for #{code}" do
              expect(fake_connection_class).to receive(:login).and_return(['banana', code])
              expect{ subject.read }.to raise_error StandardError
            end
          end
        end
      end
      context "with a session_id" do
        before(:example) do
          subject.instance_variable_set(:@session_id, 'banana')
        end
        context "where reads succeed" do
          before(:example) do
            expect(fake_connection_class).to receive(:read).and_return([[],200])
            allow(fake_parser_class).to receive(:parse_all).and_return([])
          end
          it "reads data" do
            subject.read
          end
          it "parses the output" do
            expect(fake_parser_class).to receive(:parse_all).and_return([])
            subject.read
          end
        end
        context "where reads return 401 then 200" do
          before(:example) do
            expect(fake_connection_class).to receive(:read).and_return([[],401],[[],200])
            allow(fake_parser_class).to receive(:parse_all).and_return([])
          end
          it "calls login again" do
            expect(fake_connection_class).to receive(:login).and_return(['banana',200])
            subject.read
          end
        end
        context "where reads return 401 repeatedly" do
          before(:example) do
            expect(fake_connection_class).to receive(:read).and_return([[],401],[[],401])
          end
          it "raises exception" do
            allow(fake_connection_class).to receive(:login).and_return(['banana', 200])
            expect{ subject.read }.to raise_error StandardError
          end
          it "attempts to login once" do
            expect(fake_connection_class).to receive(:login).and_return(['banana', 200])
            expect{ subject.read }.to raise_error StandardError
          end
        end
        context "where reads return 500s" do
          before(:example) do
            expect(fake_connection_class).to receive(:read).and_return([[],500],[[],500])
          end
          it "raises exception" do
	    expect(fake_connection_class).to receive(:login).and_return(['banana', 200])
            expect{ subject.read }.to raise_error StandardError
          end
        end
      end
    end
  end
end

require './lib/failure_suggester.rb'

describe FailureSuggester do
  describe "#suggestion" do
    subject(:suggested_failure) { FailureSuggester.new(line).suggest }

    context "when the line contains a constant" do
      let(:line) { "CONSTANT = 3" }
      it "suggests to modify the constant value" do
        expect(suggested_failure).not_to eq line
        expect(suggested_failure).to match(/CONSTANT = .+/)
      end
    end
  end

  describe "#detect_breakable_boundries" do
    subject(:detect) { FailureSuggester.new(line).send(:detect_breakable_boundries) }
    context "when the line contains a constant" do
      let(:line) { "CONSTANT = 3" }
      it "detects the columns that can be replaced safely" do
        expect(detect).to eq [10,12]
      end
    end
  end
end

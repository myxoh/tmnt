require './lib/inject_defect.rb'
require './lib/file_breaker.rb'
require './lib/tester.rb'

describe InjectDefect do
  context 'when modifying a production file' do
    context "when the process fails" do
      it "restores the file from the backup"
      it "ensures the backup is deleted."
    end

    it "ensures the backup is deleted."
  end

  context 'when the setup is correct' do
    subject(:uncovered_defects) { InjectDefect.new(file: file, tester: tester).run }
    let(:tester) { Tester.new(script: "rspec spec/example/spec") }
    let(:file) { FileBreaker.new('spec/example/lib/production.rb') }

    it "does not report on fully covered lines" do
      line_3_defects = uncovered_defects.find { |uncovered_defect| uncovered_defect[:line] == 3 }
      expect(line_3_defects).to be_nil
    end

    it "reports on uncovered changes." do
      line_6_defects = uncovered_defects.find { |uncovered_defect| uncovered_defect[:line] == 6 }
      expect(line_6_defects).not_to be_nil
    end
  end

  # Rspec::Matchers.define(:failed_on_line)
end

class InjectDefect
  def initialize(file:, tester: )
    @file = file
    @test = tester
  end

  def run
    non_detected_failures = []

    file.break_lines do |line_change|
      test_results = tester.test!
      if(test_results.positive?)
        non_detected_failures << line_change.changed_made
      end
    end

    non_detected_failures
  end
end

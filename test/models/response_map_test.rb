# frozen_string_literal: true

class MockMetareviewResponseMap
  attr_accessor :id
end
class ResponseMapTest < ActiveSupport::TestCase

  test "metareviewed_by?" do
    sut = ResponseMap.new
    sut.id = 1
    sut.reviewer = Participant.new
    sut.reviewer.id = 2
    metaReviewer = MockReviewer.new
    metaReviewer.id = 3
    MetareviewResponseMap.stub :where, [MockMetareviewResponseMap.new] do
      assert_equal true, sut.metareviewed_by?(metaReviewer)
    end
  end

  test "assign_metareviewer" do
    sut = ResponseMap.new
    sut.id = 1
    sut.reviewer = Participant.new
    sut.reviewer.id = 2
    metaReviewer = MockReviewer.new
    metaReviewer.id = 3
    result = MockMetareviewResponseMap.new
    result.id = 5
    MetareviewResponseMap.stub :create, result do
      assert_equal 5, sut.assign_metareviewer(metaReviewer).id
    end
  end

  test "assign_metareviewer_for_round_two" do
    sut = ResponseMap.new
    sut.id = 2
    sut.reviewer = Participant.new
    sut.reviewer.id = 2
    metaReviewer = MockReviewer.new
    metaReviewer.id = 3
    result = MockMetareviewResponseMap.new
    result.id = 2
    MetareviewResponseMap.stub :create, result do
      assert_equal 2, sut.assign_metareviewer(metaReviewer).id
    end
  end

  test "survey?" do
    sut = ResponseMap.new
    assert_equal false, sut.survey?
  end

  test "reviewee_team" do
    sut = ResponseMap.new
    assignmentTeam = MockAssignmentTeam.new
    assignmentTeam.id = 3

    AssignmentTeam.stub :find, assignmentTeam do
      assert_equal 3, sut.reviewee_team().id
    end
  end

end

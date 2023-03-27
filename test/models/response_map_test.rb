# frozen_string_literal: true
describe ResponseMap do
  let(:participant) { build(:participant, id: 1, parent_id: 1, user: student) }
  let(:participant1) { build(:participant, id: 2, parent_id: 2, user: student1) }
  let(:participant2) { build(:participant, id: 3, parent_id: 3, user: student2) }
  let(:review_response_map1) { build(:review_response_map, id: 2, assignment: assignment, reviewer: participant1, reviewee: team) }

class MockMetareviewResponseMap
  attr_accessor :id
end
class ResponseMapTest < ActiveSupport::TestCase

  test "map_id" do
    sut = ResponseMap.new
    sut.id = 1
    assert_equal 1, sut.map_id
  end

  test "all_versions" do
    sut = ResponseMap.new
    assert_equal [], sut.all_versions
  end

  test "show_review" do
    sut = ResponseMap.new
    assert_equal nil, sut.show_review
  end

  test "show_feedback" do
    sut = ResponseMap.new
    assert_equal nil, sut.show_feedback
  end

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

  describe 'assign_metareviewer for different participants' do
    context 'Assigns a metareviewer to a review' do
      it 'creates a metareview response map' do
        metareview_response_map_temp = create(:meta_review_response_map, reviewed_object_id: review_response_map1.id, reviewer_id: participant2.id, reviewee_id: participant1.id)
        allow(MetareviewResponseMap).to receive(:create).with(reviewed_object_id: review_response_map1.id, reviewer_id: participant2.id, reviewee_id: participant1.id).and_return(\
          metareview_response_map_temp
        )
        expect(review_response_map1.assign_metareviewer(participant2)).to eq(metareview_response_map_temp)
      end
    end
  end

  test "survey?" do
    sut = ResponseMap.new
    assert_equal false, sut.survey?
  end

  test "find_team_member" do
    sut = ResponseMap.new
    assignmentTeam = MockAssignmentTeam.new
    assignmentTeam.id = 3

    AssignmentTeam.stub :find, assignmentTeam do
      assert_equal 3, sut.find_team_member().id
    end
  end

end

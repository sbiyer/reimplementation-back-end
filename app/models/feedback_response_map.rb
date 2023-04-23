class FeedbackResponseMap < ResponseMap
  belongs_to :reviewee, class_name: 'Participant', foreign_key: 'reviewee_id'
  has_many :review, class_name: 'Response', foreign_key: 'reviewed_object_id'
  belongs_to :reviewer, class_name: 'AssignmentParticipant', dependent: :destroy

  # class variables
  @review_response_map_ids # stores the ids of the response map
  @temp_response_map_ids = [] # stores the ids before the rounds are classified
  @all_review_response_ids_round_one = [] # Feedback response from round 1
  @all_review_response_ids_round_two = [] # Feedback response from round 2
  @all_review_response_ids_round_three = [] # Feedback response from round 3
  @all_review_response_ids = [] # stores the ids of the reviewers response

  # get the assignment instance associated with the the instance of this feedback_response_map
  # this instance is associated with a review instance hence the lookup is chained
  def assignment
    review.map.assignment
  end

  # getter for title. All response map types have a unique title
  def title
    'Feedback'
  end


  # get the questionaries associated with this instance of the feedback response map
  # the response map belongs to an assignment hence this is a convenience function for getting the questionaires
  def author_feedback_questionnaire
    assignment.questionnaires.find_by(type: 'AuthorFeedbackQuestionnaire')
  end

  # get the reviewee of this map instance
  def contributor
    review.map.reviewee
  end

  # get a feedback response report a given review object. This provides ability to see all feedback response for a review
  # @param id is the review object id
  def self.feedback_response_report_by_round(id, round)
    @review_response_map_ids = ReviewResponseMap.where(['reviewed_object_id = ?', id]).pluck('id')
    teams = AssignmentTeam.includes([:users]).where(parent_id: id)
    authors = []
    teams.each do |team|
      team.users.each do |user|
        participant = AssignmentParticipant.where(parent_id: id, user_id: user.id).first
        authors << participant
      end
    end

    if Assignment.find(id).vary_by_round?
      @all_review_response_ids_round = nil

      # Use an iterator to filter the responses by round
      @temp_review_responses = Response.where(['map_id IN (?)', @review_response_map_ids]).order('created_at DESC')
      @temp_review_responses.each do |response|
        next if @temp_response_map_ids.include? response.map_id.to_s + response.round.to_s

        if response.round == round
          @all_review_response_ids_round = response.id
        end

        @temp_response_map_ids << response.map_id.to_s + response.round.to_s
      end
    else
      # No need to filter by round if the assignment does not vary by round
      @all_review_response_ids_round = Response.where(['map_id IN (?)', @review_response_map_ids]).pluck('id').last
    end

    # Return the response IDs for the specified round
    @all_review_response_ids_round
    
    # @feedback_response_map_ids = ResponseMap.where(["reviewed_object_id IN (?) and type = ?", @all_review_response_ids, type]).pluck("id")
    # @feedback_responses = Response.where(["map_id IN (?)", @feedback_response_map_ids]).pluck("id")
    if Assignment.find(id).vary_by_round?
      return @authors, @all_review_response_ids_round
    else
      return @authors, @all_review_response_ids
    end
  end

    # @feedback_response_map_ids = ResponseMap.where(["reviewed_object_id IN (?) and type = ?", @all_review_response_ids, type]).pluck("id")
    # @feedback_responses = Response.where(["map_id IN (?)", @feedback_response_map_ids]).pluck("id")
    if Assignment.find(id).vary_by_round?
      return @authors, @all_review_response_ids_round_one, @all_review_response_ids_round_two, @all_review_response_ids_round_three
    else
      return @authors, @all_review_response_ids
    end
  end

  # Send emails for author feedback
  # @param email_command is a command object which will be fully hydrated in this function an dpassed to the mailer service
  # email_command should be initialized to a nested hash which invoking this function {body: {}}
  # @param assignment is the assignment instance for which the email is related to
  def send_email(email_command, assignment)
    AuthorFeedbackEmailSendingMethod.send_email(email_command, assignment)
  end
end

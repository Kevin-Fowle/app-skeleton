get '/questions' do
  puts current_user
  @questions = Question.all
  erb :'questions/index'
end

get '/questions/new' do
  if current_user != nil
    erb :'questions/new'
  else
    redirect '/questions'
  end
end


get '/questions/:id' do
  @question = Question.find(params[:id])
  erb :'questions/show'
end

post '/questions' do
  @question = Question.new(params[:question])
  @question.author = current_user

  q_tags = []
  params[:question_tags].split(", ").each do |tag| tags << TagQuestion.new(question: @question, tag: Tag.find_or_create_by(name: tag))
  end

  if @question.save
    redirect "/questions/#{@question.id}"
  else
    @errors = @question.errors.full_messages
    erb :"questions/new"
  end
end

post '/questions/:id/answers' do
  @question = Question.find(params[:id])
  @answer = Answer.new(params[:answer])
  @answer.question = @question
  @answer.answerer = current_user
  if @answer.save
    redirect "/questions/#{@question.id}"
  else
    @errors = @answer.errors.full_messages
    erb :"questions/show"
  end
end

post '/questions/:question_id/answers/:answer_id/comments' do
  @question = Question.find(params[:question_id])
  @answer = Answer.find(params[:answer_id])
  @comment = Comment.new(params[:comment])
  @comment.commentable = @answer
  @comment.commenter = current_user
  if request.xhr?
    if @comment.save
      content_type :json
      return @comment.to_json
    else
      @errors = @comment.errors.full_messages
      return false
    end
  else
    if @comment.save
      redirect "/questions/#{@question.id}"
    else
      @errors = @comment.errors.full_messages
      erb :"questions/show"
    end
  end
end
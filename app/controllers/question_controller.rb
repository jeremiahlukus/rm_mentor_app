class QuestionController < UIViewController

  attr_accessor :questions 

  def viewDidLoad
    self.view = UIView.alloc.init
    self.view.userInteractionEnabled = true
    navigationItem.title = 'Ruby Quiz'
    self.view.backgroundColor = UIColor.blueColor
     @questions = [ {'body' => "Some ruby question.", 'id' => "30", 'title' => "Ruby1", 'correct' => 'True' },
                   { 'body' => "Another Ruby question",'id' => "31", 'title' => "Ruby2", 'correct' => 'True' },
                   {'body' => "last Ruby question", 'id' => "32", 'title' => "Ruby3", 'correct' => 'False' },]

     @index = -1
 #    @questions = []

    # make these the questions on the server @questions = Question.all?
    # json response is
    #
    # [#<Question:0x6040000ac000 @body="This is question one" @id=1 @title="Question 1">, 
     # #<Question:0x6040000ac300 @body="This is question two" @id=2 @title="Question 2">, 
     # #<Question:0x6040000ac540 @body="This is question three" @id=3 @title="Question 3">]
     # 
     # 
     #@questions = []
     # Question.all do |questions|
     #  update_ui_with_questions(questions) 
     # end

     
#     @questions <<  {'body' => "#{$allQuestions[0].body}", 'id' => "32", 'title' => "#{$allQuestions[0].title}", 'correct' => 'False' }
     # $allQuestions.all do |question|
     #   index = 0
     #   tmpQuestion = question[index] 
     #   tmp = { 'body' => "#{tmpQuestion.body}", 'id' => "#{tmpQuestion.id}", 'title' => "#{tmpQuestion.title}", 'correct' => "#{tmpQuestion.correct}"}
     #   @questions << tmp
     #   index += 1

     # end
     load_questions
  end

  def refreshLoad
    self.view = UIView.alloc.init
    self.view.userInteractionEnabled = true
    navigationItem.title = 'Ruby Quiz'
    self.view.backgroundColor = UIColor.blueColor
    @index = -1
     load_questions
  end

 
  def load_questions
    Question.all do |questions|
      display_questions(questions)
    end
  end 
  $count = 0

  def display_questions(questions)
     @questions = [ {'body' => "Some ruby question.", 'id' => "30", 'title' => "Ruby1", 'correct' => 'True' },
                   { 'body' => "Another Ruby question",'id' => "31", 'title' => "Ruby2", 'correct' => 'True' },
                   {'body' => "last Ruby question", 'id' => "32", 'title' => "Ruby3", 'correct' => 'False' },]

 
    questions.each do |question|
      if $count != questions.count  
        @questions <<  {'body' => "#{questions[$count].body}", 'id' => "#{questions[$count].id}", 'title' => "#{questions[$count].title}", 'correct' => 'False' }
        puts @questions
        $count += 1
        puts $count
      end 
    end

     screen_setup
  end

  def screen_setup
    @questions <<  {'body' => " '", 'id' => "33", 'title' => " '", 'correct' => 'False' }
    @total = @questions.count 

    @question_title = UILabel.new
    @question_title.font = UIFont.systemFontOfSize(24)
    @question_title.backgroundColor = UIColor.clearColor
    @question_title.lineBreakMode = UILineBreakModeWordWrap
    @question_title.font = UIFont.fontWithName("Helvetica", size:30)
    @question_title.color = UIColor.whiteColor
    @question_title.numberOfLines = 0
    @question_title.frame = [[40,50], [343, 79]]
    view.addSubview @question_title

    @question_label = UILabel.new
    @question_label.font = UIFont.systemFontOfSize(24)
    @question_label.backgroundColor = UIColor.clearColor
    @question_label.font = UIFont.fontWithName("Helvetica", size:20)
    @question_label.color = UIColor.whiteColor
    @question_label.lineBreakMode = UILineBreakModeWordWrap
    @question_label.numberOfLines = 0
    @question_label.frame = [[40, 142], [359, 213]]
    view.addSubview @question_label

    answer_true = UIButton.buttonWithType(UIButtonTypeCustom)
    answer_true.frame = [[10,380], [155,56]]
    answer_true.setTitle "True" , forState: UIControlStateNormal
    answer_true.backgroundColor = UIColor.greenColor
    answer_true.tag = 0
    answer_true.addTarget(self, action:'show_answer:', forControlEvents: UIControlEventTouchUpInside)
    view.addSubview answer_true

    answer_false = UIButton.buttonWithType(UIButtonTypeCustom)
    answer_false.frame = [[194,380], [155,56]]
    answer_false.setTitle "True" , forState: UIControlStateNormal
    answer_false.backgroundColor = UIColor.redColor
    answer_false.tag = 1
    answer_false.addTarget(self, action:'show_answer:', forControlEvents: UIControlEventTouchUpInside)
    view.addSubview answer_false

    @result_label = UILabel.new
    @result_label.font = UIFont.systemFontOfSize(20)
    @result_label.backgroundColor = UIColor.clearColor
    @result_label.textAlignment = UITextAlignmentCenter
    @result_label.frame = [110, 195], [155, 56]
    view.addSubview @result_label

    @score_label = UILabel.new
    @score_label.font = UIFont.systemFontOfSize(30)
    @score_label.backgroundColor = UIColor.clearColor
    @score_label.textAlignment = UITextAlignmentCenter
    @score_label.frame = [[120, 480], [80, 30]]
    view.addSubview @score_label

    reset_quiz

    if @questions.count == 4
      puts "Count == 4"
    end

    get_question
  end

  private
  def show_answer(sender)
    correct = @questions[@index]['correct'] == 'True' ? 0 : 1 
    if sender.tag == correct
      @score += 1 
      @result_label.text = "Correct!"
      @result_label.textColor = UIColor.greenColor 
    else
      @result_label.text = "Incorrect! The answer was #{@questions[@index]['correct'].downcase}."
      @result_label.textColor = UIColor.redColor 
    end

    @score_label.text = "#{@score}/#{@total - 1}"

    if @index == @total
      @index = -1
      show_alert('Finished', "Yor are now being redirected back to feedback", 'OK')
      show_alert('Quiz Complete', "Your final score was #{@score}/#{@questions.count - 1 }", 'OK')
      feedbackController
    else
      get_question
    end
  end

  def feedbackController 
    UIApplication.sharedApplication.delegate.refresh_view
  end


  def get_question
    @index +=1
    if @index >= (@questions.count - 1)
      show_alert('Finished', "Yor are now being redirected back to feedback", 'OK')
      show_alert('Quiz Complete', "Your final score was #{@score}/#{@questions.count - 1}", 'OK')
      feedbackController
    end

    if @questions.count == 0 
      puts "In if statement"
      refreshLoad
    else 

      @question_title.text = @questions[@index]['title']
      @question_title.frame = [[50,60 ], [343, 79]]
      @question_title.sizeToFit

      @question_label.text = @questions[@index]['body']
      @question_label.frame = [[50, 142], [359, 213]]
      @question_label.sizeToFit
    end
  end

  def reset_quiz
    #@questions = @questions.shuffle
    @score = 0
    @index = -1
    @score_label.text = "0/#{@questions.count - 1}"
    @result_label.text = ""
    @result_label.textColor = UIColor.blackColor 
  end

  def show_alert(title, message, button)
    alert = UIAlertView.new
    alert.delegate = self
    alert.title = title
    alert.message = message
    alert.addButtonWithTitle(button)
    alert.show
  end

  def alertView(alertView, didDismissWithButtonIndex: indexPath)
    reset_quiz
    get_question
  end

end

class QuestionController < UIViewController

  def viewDidLoad
    self.view = UIView.alloc.init
    self.view.backgroundColor = UIColor.whiteColor
    self.view.userInteractionEnabled = true
    navigationItem.title = 'Ruby Quiz'
    self.view.backgroundColor = UIColor.blueColor

    # make these the questions on the server @questions = Question.all?
    @questions = [ { 'title' => "Ruby1", 'body' => "Some ruby question.", 'correct' => 'True' },
                   { 'title' => "Ruby2", 'body' => "Another Ruby question", 'correct' => 'True' },
                   { 'title' => "Ruby3", 'body' => "last Ruby question", 'correct' => 'False' },]

    screen_setup
  end


  def screen_setup
    @total = 3 
                                                                                                                         
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

    @score_label.text = "#{@score}/3"

    if @index == 2
      show_alert('Finished', "Yor are now being redirected back to feedback", 'OK')
      show_alert('Quiz Complete', "Your final score was #{@score}/3", 'OK')
      feedbackController
    else
      get_question
    end
  end
  def feedbackController 
    view_b = FeedbackController.alloc.init
    self.presentViewController view_b, animated:true, completion:nil
  end


  def get_question
    @index +=1
    @question_title.text = @questions[@index]['title']
    @question_title.text = @questions[@index]['title']
    @question_title.frame = [[50,60 ], [343, 79]]
    @question_title.sizeToFit

    @question_label.text = @questions[@index]['body']
    @question_label.text = @questions[@index]['body']
    @question_label.frame = [[50, 142], [359, 213]]
    @question_label.sizeToFit
  end

  def reset_quiz
    @questions = @questions.shuffle
    @score = 0
    @index = -1
    @score_label.text = "0/3"
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

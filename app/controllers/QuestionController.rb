class QuestionController < UIViewController 

  attr_accessor :questions

  def viewDidLoad 
    super
    puts "Hey"

    self.questions = []
    self.title = "Questions"
    
    puts self.questions.count


  end
  def refresh
    #SVProgressHUD.showWithStatus("Loading", maskType:SVProgressHUDMaskTypeGradient)
    Question.all do |jsonfeedbacks|
      self.questions.clear
      self.questions = jsonfeedbacks
      #@feedbacksTableView.reloadData
      # SVProgressHUD.dismiss
    end
  end


end 

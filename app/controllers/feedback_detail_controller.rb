class FeedbackDetailController < UIViewController 

  def initWithFeedbackDetails(feedbackDetails)
    init
    $feedbackDetails = feedbackDetails
    self.title = $feedbackDetails.title
    self
  end

  def viewDidLoad
    $feedbackDetailView = FeedbackDetailView.alloc.initWithFrame(self.view.frame)
    $feedbackDetailView.contentView.text = $feedbackDetails.body
    self.view.addSubview($feedbackDetailView)
  end


end 

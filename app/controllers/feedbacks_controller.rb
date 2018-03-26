class FeedbackController < UIViewController
  attr_accessor :feedbacks

  def self.controller
    @controller ||= FeedbackController.alloc.initWithNibName(nil, bundle:nil)
  end

  def viewDidLoad
    super
    self.feedbacks = []
    self.title = "Feedbacks"
    self.view.backgroundColor = UIColor.whiteColor
    make_nav 
    @feedbacksTableView = UITableView.alloc.initWithFrame([[0, 0],
                                                      [self.view.bounds.size.width, self.view.bounds.size.height]],
                                                      style:UITableViewStylePlain)
    @feedbacksTableView.dataSource = self
    @feedbacksTableView.delegate = self
    @feedbacksTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight 

    puts "\nHey in view did load\n"

    self.view.addSubview(@feedbacksTableView)
    refresh if App::Persistence['authToken']
  end

  def make_nav 
    logoutButton = UIBarButtonItem.alloc.initWithTitle("Logout", style:UIBarButtonItemStylePlain, target:self, action:'logout')
    self.navigationItem.leftBarButtonItem = logoutButton
    refreshButton = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh, target:self, action:'refresh')
    newFeedbackButton = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAdd,target:self,action:'addNewFeedback')
    questionButton = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemPlay,target:self,action:'questionController')
    cameraButton = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemCamera,target:self,action:'cameraController')
    self.navigationItem.rightBarButtonItems = [questionButton, refreshButton, newFeedbackButton, cameraButton]
  end


  # UITableView delegate methods
  def tableView(tableView, numberOfRowsInSection:section)
    self.feedbacks.count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
    UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier:@reuseIdentifier)
    end

    feedback = self.feedbacks[indexPath.row]

    cell.textLabel.text = feedback.title
    cell.detailTextLabel.text = feedback.body

    if feedback.completed
      cell.textLabel.color = '#aaaaaa'.to_color
      cell.accessoryType = UITableViewCellAccessoryCheckmark
    else
      cell.textLabel.color = '#222222'.to_color
      cell.accessoryType = UITableViewCellAccessoryNone
    end

    cell
  end

  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    # tableView.deselectRowAtIndexPath(indexPath, animated:true)
     feedback = self.feedbacks[indexPath.row]


    feedbackDetailController = FeedbackDetailController.alloc.initWithFeedbackDetails(self.feedbacks[indexPath.row])
     self.navigationController.pushViewController(feedbackDetailController, animated:true) 
    feedback.toggle_completed do
      refresh
    end
  end

  # Controller methods
  def refresh
    #SVProgressHUD.showWithStatus("Loading", maskType:SVProgressHUDMaskTypeGradient)
    Feedback.all do |jsonfeedbacks|
      self.feedbacks.clear
      self.feedbacks = jsonfeedbacks
      @feedbacksTableView.reloadData
      # SVProgressHUD.dismiss
    end
  end

  def questionController
    question_view = QuestionController.alloc.init
    self.presentViewController question_view, animated:true, completion:nil
  end

  def cameraController
    camera_view = CameraController.alloc.init
    self.presentViewController camera_view, animated:true, completion:nil
  end


  def addNewFeedback
    # @newFeedbackController = NewfeedbackController.alloc.init
    # @newFeedbackNavigationController = UINavigationController.alloc.init
    # @newFeedbackNavigationController.pushViewController(@newfeedbackController, animated:false)
    # @newFeedbackNavigationController.navigationBar.configureFlatNavigationBarWithColor(UIColor.midnightBlueColor)

    # self.presentModalViewController(@newFeedbackNavigationController, animated:true)
  end

  def logout
    UIApplication.sharedApplication.delegate.logout
  end
end

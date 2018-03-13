class FeedbackController < UIViewController

  def self.controller
    @controller ||= FeedbackController.alloc.initWithNibName(nil, bundle:nil)
  end

  def viewDidLoad
    super

    self.feedbacks = []

    self.title = "Your feedbacks"
    self.view.backgroundColor = UIColor.whiteColor

    logoutButton = UIBarButtonItem.alloc.initWithTitle("Logout",
                                                       style:UIBarButtonItemStylePlain,
                                                       target:self,
                                                       action:'logout')
    self.navigationItem.leftBarButtonItem = logoutButton 

    refreshButton = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh,
                                                                      target:self,
                                                                      action:'refresh')
    self.navigationItem.rightBarButtonItems = [refreshButton]

    @feedbacksTableView = UITableView.alloc.initWithFrame([[0, 0],
                                                       [self.view.bounds.size.width, self.view.bounds.size.height]],
    style:UITableViewStylePlain)
    @feedbacksTableView.dataSource = self
    @feedbacksTableView.delegate = self
    @feedbacksTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight

    self.view.addSubview(@feedbacksTableView)

    refresh if App::Persistence['authToken']
  end

  # UITableView delegate methods
  def tableView(tableView, numberOfRowsInSection:section)
    self.feedbacks.count
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    @reuseIdentifier ||= "CELL_IDENTIFIER"

    cell = tableView.dequeueReusableCellWithIdentifier(@reuseIdentifier) || begin
    UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:@reuseIdentifier)
    end

    feedback = self.feedbacks[indexPath.row]

    cell.textLabel.text = feedback.title

    cell
  end

  # Controller methods
  def refresh
    #SVProgressHUD.showWithStatus("Loading", maskType:SVProgressHUDMaskTypeGradient)
    feedback.all do |jsonfeedbacks|
      self.feedbacks.clear
      self.feedbacks = jsonfeedbacks
      @feedbacksTableView.reloadData
     # SVProgressHUD.dismiss
    end
  end

  def logout
    UIApplication.sharedApplication.delegate.logout
  end
end

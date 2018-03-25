class WelcomeController < UIViewController

  def self.controller
    @controller ||= WelcomeController.alloc.initWithNibName(nil, bundle:nil)
  end

  def viewDidLoad
    super

    self.title = "Welcome"
    self.view.backgroundColor = UIColor.whiteColor
    view.userInteractionEnabled = true
    @containerView = UIView.alloc.initWithFrame([[0, 0], [self.view.frame.size.width, UIScreen.mainScreen.bounds.size.height]])
    @containerView.userInteractionEnabled = true
    backgroundImageView = UIImageView.alloc.initWithFrame([[0,0], [800, UIScreen.mainScreen.bounds.size.height]])
    backgroundImageView.image = UIImage.imageNamed("background.jpg")
    @containerView.addSubview backgroundImageView

    @welcomeTitleLabel = UILabel.alloc.initWithFrame([[10, 100], [self.view.frame.size.width - 20, 20]])
    @welcomeTitleLabel.font = UIFont.boldSystemFontOfSize(20)
    @welcomeTitleLabel.text = 'Welcome to Mentor Synergy!'
    @welcomeTitleLabel.textAlignment = NSTextAlignmentCenter

    @containerView.addSubview(@welcomeTitleLabel)

    @welcomeLabel = UILabel.alloc.initWithFrame([[10, 150], [self.view.frame.size.width - 20, 20]])
    @welcomeLabel.text = 'Registor or Login to unlock your life'
    @welcomeLabel.textAlignment = NSTextAlignmentCenter

    @containerView.addSubview(@welcomeLabel)

    @registerButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @registerButton.frame = [[10, 195], [(self.view.frame.size.width  / 2) - 15, 40]]
    @registerButton.setTitle('Register', forState: UIControlStateNormal)
    @registerButton.addTarget(self,
                              action:'register',
                              forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@registerButton)

    @loginButton = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @loginButton.frame = [[(self.view.frame.size.width  / 2) + 5, 195], [(self.view.frame.size.width  / 2) - 15, 40]]
    @loginButton.setTitle('Login', forState: UIControlStateNormal)
    @loginButton.addTarget(self,
                           action:'login',
                           forControlEvents:UIControlEventTouchUpInside)

    @containerView.addSubview(@loginButton)

    # Finally add the scrollview to the main view
    self.view.addSubview(@containerView)
  end

  def register
    @registerController = RegisterController.alloc.init
    self.navigationController.pushViewController(@registerController, animated:true)
  end

  def login
    @loginController = LoginController.alloc.init
    self.navigationController.pushViewController(@loginController, animated:true)
  end
end

class AppDelegate

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @navigationController = UINavigationController.alloc.init
    @navigationController.pushViewController(FeedbackController.controller, animated:false)
    StylingKit.sharedKit.startStyling

    @window.rootViewController = @navigationController
    @window.makeKeyAndVisible

    if App::Persistence['authToken'].nil?
      showWelcomeController
    end

    return true
  end

  def refresh_view 
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    @navigationController = UINavigationController.alloc.init
    @navigationController.pushViewController(FeedbackController.controller, animated:false)

    @window.rootViewController = @navigationController
    @window.makeKeyAndVisible

    if App::Persistence['authToken'].nil?
      showWelcomeController
    end

    return true
  end
 

  def showWelcomeController
    @welcomeController = WelcomeController.alloc.init
    @welcomeNavigationController = UINavigationController.alloc.init
    @welcomeNavigationController.pushViewController(@welcomeController, animated:false)

    FeedbackController.controller.presentModalViewController(@welcomeNavigationController,
                                                              animated:true)
  end
    def logout
    headers = {
      'Content-Type' => 'application/json',
      'Authorization' => "Token token=\"#{App::Persistence['authToken']}\""
    }

    BW::HTTP.delete("https://rails-mentor-api.herokuapp.com/sessions.json", { headers: headers }) do |response|
      App::Persistence['authToken'] = nil
      showWelcomeController
    end
    end

end

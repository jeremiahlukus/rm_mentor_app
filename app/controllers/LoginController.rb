class LoginController < PM::XLFormScreen 
  API_LOGIN_ENDPOINT = "http://localhost:3000/sessions.json"

  form_options on_save: :login

  def form_data
    [
      {
        title: "Login",
        cells: [
          {
            title: "Email",
            name: :email,
            placeholder: "me@mail.com",
            type: :email,
            auto_correction: :no,
            auto_capitalization: :none
          },{ 
            title: "Password",
            name: :password,
            placeholder: "required",
            type: :password,
            secure: true
          },
          {

            title: "Login",
            name: :save,
            type: :button,
            on_click: -> (cell){
              on_save(nil)
            }
          }
        ]
      }]

    #super.initWithForm(form)
  end


  def login(form)
    mp form
    headers = { 'Content-Type' => 'application/json' }
    data = BW::JSON.generate({ user: {
      email: form['email'],
      password: form['password']
    } })
    mp data
    #SVProgressHUD.showWithStatus("Logging in", maskType:SVProgressHUDMaskTypeGradient)
    BW::HTTP.post(API_LOGIN_ENDPOINT, { headers: headers, payload: data } ) do |response|
      if response.status_description.nil?
          alert = UIAlertView.alloc.initWithTitle("Login Successful",
                                                  message: response.error_message,
                                                   delegate: nil,
                                                   cancelButtonTitle: "OK",
                                                   otherButtonTitles: nil)
          alert.show
        
      else
        if response.ok?
          json = BW::JSON.parse(response.body.to_s)
          App::Persistence['authToken'] = json['data']['auth_token']
          #App.alert(json['info'])
          alert = UIAlertView.alloc.initWithTitle("Login Successful",
                                                   message: json['info'],
                                                   delegate: nil,
                                                   cancelButtonTitle: "OK",
                                                   otherButtonTitles: nil)
          alert.show
         
          self.navigationController.dismissModalViewControllerAnimated(true)
          FeedbackController.controller.refresh
        elsif response.status_code.to_s =~ /40\d/
          alert = UIAlertView.alloc.initWithTitle("Login Failed",
                                                   message: "Please Try Again",
                                                   delegate: nil,
                                                   cancelButtonTitle: "OK",
                                                   otherButtonTitles: nil)
          alert.show
          #App.alert("Login failed")
        else
          alert =  UIAlertView.alloc.initWithTitle("Error",
                                                    message: response.to_s,
                                                    delegate: nil,
                                                    cancelButtonTitle: "OK",
                                                    otherButtonTitles: nil)
          alert.show

        end
      end
      #SVProgressHUD.dismiss
    end
  end
end

class RegisterController < PM::XLFormScreen  
  API_REGISTER_ENDPOINT = "http://localhost:3000/registrations.json"


form_options on_save: :register 

  def form_data 
    [
      {
        title: "Register", 
        cells: [
          { 
            title: "Email",
            name: :email,
            placeholder: "me@mail.com",
            type: :email,
            auto_correction: :no,
            auto_capitalization: :none
          }, {
            title: "Username",
            name: :name,
            placeholder: "choose a name",
            type: :name,
            auto_correction: :no,
            auto_capitalization: :none
          }, {
            title: "Password",
            name: :password,
            placeholder: "required",
            type: :password,
            secure: true
          }, {
            title: "Confirm Password",
            name: :password_confirmation,
            placeholder: "required",
            type: :password,
            secure: true
          },
          {
            title: "Your email address will always remain private.\nBy clicking Register you are indicating that you have read and agreed to the terms of service",
            title: "Register",
            name: :save,
            type: :button,
            on_click: -> (cell){
              on_save(nil)
            }
          }
        ]
      }]
  end

  def register(form)
    mp form 
    headers = { 'Content-Type' => 'application/json' }
    data = BW::JSON.generate({ user: {
      email: form['email'],
      name: form['name'],
      password: form['password'],
      password_confirmation: form['password_confirmation']
    } })

    mp data
    if form['email'].nil? ||
        form['name'].nil? ||
        form['password'].nil? ||
        form['password_confirmation'].nil?
      alert = UIAlertView.alloc.initWithTitle("Incomplete",
                                              message: "Please complete all fields",
                                              delegate: nil,
                                              cancelButtonTitle: "OK",
                                              otherButtonTitles: nil)
      alert.show
    else
      if form['password'] != form['password_confirmation']
      alert = UIAlertView.alloc.initWithTitle("Passwords do not match",
                                              message: "Your password doesn't match confirmation, check again",
                                              delegate: nil,
                                              cancelButtonTitle: "OK",
                                              otherButtonTitles: nil)
      alert.show

      else
        #SVProgressHUD.showWithStatus("Registering new account...", maskType:SVProgressHUDMaskTypeGradient)
        BW::HTTP.post(API_REGISTER_ENDPOINT, { headers: headers , payload: data } ) do |response|
          if response.status_description.nil?
            alert = UIAlertView.alloc.initWithTitle("Error",
                                                    message: response.error_message,
                                                    delegate: nil,
                                                    cancelButtonTitle: "OK",
                                                    otherButtonTitles: nil)
            alert.show
          else
            if response.ok?
              json = BW::JSON.parse(response.body.to_str)
              App::Persistence['authToken'] = json['data']['auth_token']
                       alert = UIAlertView.alloc.initWithTitle("Registration Successful",
                                                   message: json['info'],
                                                   delegate: nil,
                                                   cancelButtonTitle: "OK",
                                                   otherButtonTitles: nil)
                      alert.show
              self.navigationController.dismissModalViewControllerAnimated(true)
              FeedbackController.controller.refresh
            elsif response.status_code.to_s =~ /40\d/
                      alert = UIAlertView.alloc.initWithTitle("Registration Failed",
                                                   message: "Please Try Again",
                                                   delegate: nil,
                                                   cancelButtonTitle: "OK",
                                                   otherButtonTitles: nil)
                      alert.show
            else
              alert =  UIAlertView.alloc.initWithTitle("Error",
                                                       message: response.to_s,
                                                       delegate: nil,
                                                       cancelButtonTitle: "OK",
                                                       otherButtonTitles: nil)
              alert.show
            end
          end
         # SVProgressHUD.dismiss
        end
      end
    end
  end
end

class RequestController < PM::XLFormScreen  
  API_REQUEST_ENDPOINT = "https://rails-mentor-api.herokuapp.com/requests.json"
 # API_REQUEST_ENDPOINT = "http://localhost:3000/requests.json"

  form_options on_save: :request 

  def form_data 
    subjects = [
      { id: :ruby, name: 'Ruby' },
      { id: :python, name: 'Python' },
      { id: :javascript, name: 'Javascript' },
      { id: :java,  name: 'Java' },
    ]

    details = [
      { id: :testing, name: 'Testing' },
      { id: :refactoring, name: 'Refactoring' },
      { id: :querying, name: 'Querying' },
      { id: :interview, name: 'Interview' },
    ]

    [
      {
        title:  'Request information',
        cells: [
          {
            title: 'What Subject?',
            name: :subject,
            type: :selector_picker_view_inline,
            options: Hash[subjects.map do |subject|
              [subject[:id], subject[:name]]
            end]
          },
          {
            title: 'What is your weak point?',
            name: :detail,
            type: :selector_picker_view_inline,
            options: Hash[details.map do |detail|
              [detail[:id], detail[:name]]
            end]
          },
          {
            title: "Send Request",
            name: :save,
            type: :button,
            on_click: -> (cell){
              on_save(nil)
            }
          }

        ]
      }
    ]
  end

  def request(form)
    mp form 
    headers = { 'Content-Type' => 'application/json' }
    data = BW::JSON.generate({ request: {
      subject: form['subject'],
      detail: form['detail'],
    } })
    BW::HTTP.post(API_REQUEST_ENDPOINT, { headers: headers , payload: data } ) do |response|

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
          alert = UIAlertView.alloc.initWithTitle("Request Successful",
                                                  message: json['info'],
                                                  delegate: nil,
                                                  cancelButtonTitle: "OK",
                                                  otherButtonTitles: nil)
          alert.show
          FeedbackController.controller.refresh
        elsif response.status_code.to_s =~ /40\d/
          alert = UIAlertView.alloc.initWithTitle("Request Failed",
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

      UIApplication.sharedApplication.delegate.refresh_view
    end 
  end


end


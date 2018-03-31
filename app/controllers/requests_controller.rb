class RequestController < PM::XLFormScreen  
  API_REGISTER_ENDPOINT = "https://rails-mentor-api.herokuapp.com/registrations.json"


  form_options on_save: :request 

  def form_data 
    subjects = [
      { id: :ruby, name: 'Ruby' },
      { id: :python, name: 'Python' },
      { id: :javascript, name: 'Javascript' },
      { id: :java,  name: 'Java' },
    ]

    guidences = [
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
            name: :quidence,
            type: :selector_picker_view_inline,
            options: Hash[guidences.map do |guidence|
              [guidence[:id], guidence[:name]]
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
  end 


end


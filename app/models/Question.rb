class Question
  API_QUESTIONS_ENDPOINT = "http://localhost:3000/questions"

  
  PROPERTIES = [:id, :title, :body, :correct] 

  PROPERTIES.each do |prop|
    attr_accessor prop
  end

  def initialize(hash = {})
    hash.each do |key, value|
      if PROPERTIES.member? key.to_sym
        self.send((key.to_s + "=").to_s, value)
      end
    end
  end

  def self.all(&block)
    BW::HTTP.get("#{API_QUESTIONS_ENDPOINT}.json", { headers: Question.headers }) do |response|
      if response.status_description.nil?
        App.alert(response.error_message)
      else
        if response.ok?
          alert = UIAlertView.alloc.initWithTitle("You are in",
                                                  message: response.body,
                                                  delegate: nil,
                                                  cancelButtonTitle: "OK",
                                                  otherButtonTitles: nil)
          alert.show
          $json = BW::JSON.parse(response.body.to_s)
          $questions = json.map { |question| Question.new(question) }
          puts "#{$questions}"
          block.call($questions)
        elsif response.status_code.to_s =~ /40\d/
          alert = UIAlertView.alloc.initWithTitle("Not authorized",
                                                  message: "Not authorized",
                                                  delegate: nil,
                                                  cancelButtonTitle: "OK",
                                                  otherButtonTitles: nil)
          alert.show
        else
          alert = UIAlertView.alloc.initWithTitle("Something went wrong",
                                                  message: "Try again",
                                                  delegate: nil,
                                                  cancelButtonTitle: "OK",
                                                  otherButtonTitles: nil)
          alert.show
        end
      end
    end
  end

  def self.create(params = {}, &block)
    data = BW::JSON.generate(params)

    BW::HTTP.post("#{API_QUESTIONS_ENDPOINT}.json", { headers: Question.headers, payload: data } ) do |response|
      if response.status_description.nil?
        alert = UIAlertView.alloc.initWithTitle("Error",
                                                message: response.error_message,
                                                delegate: nil,
                                                cancelButtonTitle: "OK",
                                                otherButtonTitles: nil)
        alert.show
      else
        if response.ok?
          json = BW::JSON.parse(response.body.to_s)
          block.call(json)
        elsif response.status_code.to_s =~ /40\d/
          alert = UIAlertView.alloc.initWithTitle("question creation failed",
                                                  message: "Try again",
                                                  delegate: nil,
                                                  cancelButtonTitle: "OK",
                                                  otherButtonTitles: nil)
          alert.show
        else
          alert = UIAlertView.alloc.initWithTitle("Error",
                                                  message: response.to_s,
                                                  delegate: nil,
                                                  cancelButtonTitle: "OK",
                                                  otherButtonTitles: nil)
          alert.show
        end
      end
    end
  end

  def toggle_completed(&block)
    url = "#{API_QUESTIONS_ENDPOINT}/#{self.id}/#{self.completed ? 'open' : 'complete'}.json"
    BW::HTTP.put(url, { headers: question.headers }) do |response|
      if response.status_description.nil?
        alert = UIAlertView.alloc.initWithTitle("Error",
                                                message: response.error_message,
                                                delegate: nil,
                                                cancelButtonTitle: "OK",
                                                otherButtonTitles: nil)
        alert.show
      else
        if response.ok?
          json = BW::JSON.parse(response.body.to_s)
          questionData = json[:data][:question]
          question = Question.new(questionData)
          block.call(question)
        elsif response.status_code.to_s =~ /40\d/
          alert = UIAlertView.alloc.initWithTitle("Not authorized",
                                                  message: "Not authorized",
                                                  delegate: nil,
                                                  cancelButtonTitle: "OK",
                                                  otherButtonTitles: nil)
          alert.show
        else
          alert = UIAlertView.alloc.initWithTitle("Something weird happened",
                                                  message: "Something happend",
                                                  delegate: nil,
                                                  cancelButtonTitle: "OK",
                                                  otherButtonTitles: nil)
          alert.show
        end
      end
    end
  end

  def self.headers
    {
      'Content-Type' => 'application/json',
      'Authorization' => "Token token=\"#{App::Persistence['authToken']}\""
    }
  end
end

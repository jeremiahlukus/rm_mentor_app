class Feedback
  API_FEEDBACKS_ENDPOINT = "https://rails-mentor-api.herokuapp.com/feedbacks"


  PROPERTIES = [:body,:id, :title,:user_id, :completed, :recipient_id] 

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
    BW::HTTP.get("#{API_FEEDBACKS_ENDPOINT}.json", { headers: Feedback.headers }) do |response|
      if response.status_description.nil?
        App.alert(response.error_message)
      else
        if response.ok?
          # alert = UIAlertView.alloc.initWithTitle("Your in",
          #                                         message: response.body,
          #                                         delegate: nil,
          #                                         cancelButtonTitle: "OK",
          #                                         otherButtonTitles: nil)
          # alert.show
          json = BW::JSON.parse(response.body.to_s)
          # feedbacksData = json['data']['feedbacks'] || []
          feedbacks = json.map { |feedback| Feedback.new(feedback) }
          puts "#{feedbacks}"
          block.call(feedbacks)
        elsif response.status_code.to_s =~ /40\d/
          alert = UIAlertView.alloc.initWithTitle("All Not authorized",
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

    BW::HTTP.post("#{API_FEEDBACKS_ENDPOINT}.json", { headers: Feedback.headers, payload: data } ) do |response|
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
          alert = UIAlertView.alloc.initWithTitle("Feedback creation failed",
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

    url = "#{API_FEEDBACKS_ENDPOINT}/#{self.id}/#{self.completed ? 'open' : 'complete'}"
    puts url 
    puts self
    puts self.id
    BW::HTTP.get(url, { headers: Feedback.headers }) do |response|
      if response.status_description.nil?
        alert = UIAlertView.alloc.initWithTitle("Error",
                                                message: response.error_message,
                                                delegate: nil,
                                                cancelButtonTitle: "OK",
                                                otherButtonTitles: nil)
        alert.show
      else
        if response.ok?
          puts "Response OK and visited #{url}"
        elsif response.status_code.to_s =~ /40\d/
          puts response 

          alert = UIAlertView.alloc.initWithTitle("Toggle Not authorized",
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

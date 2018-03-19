class QuestionController < UIViewController 

#  include BW::KVO
  attr_accessor :questions

  def self.controller
    @controller ||= QuestionController.alloc.initWithNibName(nil, bundle:nil)
  end
  def viewDidLoad 
    super
    self.view.userInteractionEnabled = true 
    self.view.backgroundColor = UIColor.blueColor 

    Question.all do |question|
      puts "#{question}"
    end

  end 

end

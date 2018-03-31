class CameraController < UIViewController

  def viewDidLoad
    view.backgroundColor = UIColor.underPageBackgroundColor
    loadButtons
  end

  def loadButtons
    @camera_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @camera_button.frame  = [[50, 20], [200, 50]]
    @camera_button.setTitle("Click from camera", forState:UIControlStateNormal)
    @camera_button.addTarget(self, action: :start_camera, forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(@camera_button)

    @gallery_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @gallery_button.frame  = [[50, 100], [200, 50]]
    @gallery_button.setTitle("Chose from Gallery", forState:UIControlStateNormal)
    @gallery_button.addTarget(self, action: :open_gallery, forControlEvents:UIControlEventTouchUpInside)
    view.addSubview(@gallery_button)

    @image_picker = UIImagePickerController.alloc.init
    @image_picker.delegate = self
  end

  #Tells the delegate that the user picked a still image or movie.
  def imagePickerController(picker, didFinishPickingImage:image, editingInfo:info)
    self.dismissModalViewControllerAnimated(true)
    @image_view.removeFromSuperview if @image_view
    @image_view = UIImageView.alloc.initWithImage(image)
    @image_view.frame = [[50, 200], [200, 180]]
    view.addSubview(@image_view)
  end

  def start_camera
    if camera_present
      @image_picker.sourceType = UIImagePickerControllerSourceTypeCamera
      presentModalViewController(@image_picker, animated:true)
    else
      show_alert
    end
  end

  def open_gallery
    @image_picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary
    presentModalViewController(@image_picker, animated:true)
  end

  def show_alert
    alert = UIAlertView.new  
    alert.message = 'No Camera in device'
    alert.show
  end

  #Check Camera available or not
  def camera_present
    UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceTypeCamera)
  end
end

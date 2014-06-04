Pod::Spec.new do |s|
	s.name         = "MYSDynamicAlertView"
	s.version      = "0.0.1"
	s.summary      = "An alert view that uses UIKit Dynamics to present a fun/interactive way to respond to alerts."
	s.description  = <<-DESC
	A longer description of MYSGravityActionSheet in Markdown format.

	* Think: Why did you write this? What is the focus? What does it do?
	* CocoaPods will be using this to generate tags, and improve search results.
	* Try to keep it short, snappy and to the point.
	* Finally, don't worry about the indent, CocoaPods strips it!
	DESC
	s.homepage     = "https://github.com/mysterioustrousers/MYSDynamicAlertView"
	s.license      = "MIT"
	s.author       = { "Dan Willoughby" => "amozoss@gmail.com" }
	s.platform     = :ios, "7.0"
	s.source       =  {
		:git => "https://github.com/mysterioustrousers/MYSDynamicAlertView.git",
		:tag => "#{s.version}",
	}
	s.source_files  = "MYSDynamicAlertView/*.{h,m}"
	s.requires_arc = true
end

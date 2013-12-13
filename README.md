Rails "lite"

This one day project implements some of the basic functionality from Rails.

"Features"

Built on WEBrick, taking advantage of WEBrick::Response, WEBrick::Request, and WEBrick::Cookie.
A base class for controllers to inherit from which allows rendering, redirecting, and much more.
Ability for session and flash management via cookies.
Ability to define routes linked to Controller Action. Visiting those routes with a browser will trigger controller actions.
Params can be passed via three ways.
Via the web. I.e., http://someurl.com/users/2
Via request bodies. I.e., submitting a form.
Via a query string. http://someurl.com/users?age=20
Ability to access and render ERB templates. Will render the template based on the controller action if not told otherwise.


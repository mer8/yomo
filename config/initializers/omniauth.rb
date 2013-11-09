Rails.application.config.middleware.use OmniAuth::Builder do
	provider :google_oauth2, 
	'434092699375.apps.googleusercontent.com','or1NmEWn2QOmObdok9No6jcV', 
		{scope: 'userinfo.email, userinfo.profile, https://www.googleapis.com/auth/yt-analytics.readonly', name: "google_login", approval_prompt: ''}
end
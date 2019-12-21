# delete_tweets
Ruby script to mass-delete data from Twitter

This is a simple Ruby app to delete Tweets, Likes or Direct Messages from Twitter.

The app was designed from scratch, a simple MVC app with direct API calls, not using the twitter gem or any other available code.

The app requires what Twitter calls a "consumer key", which can be obtained by registering a developer account on Twitter. You must obtain those manually and input them in an .env file, or directly into the app.rb file.

After the consumer keys are obtained, the app itself will get access tokens from a user in order to access all data from a Twitter account.

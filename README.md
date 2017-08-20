# U custom utilites

### Prerequesites

* git
* ruby 2.x
* bundler

git clone this repository, cd into it, and then run

	bundle
	./u install to path

This will symlink the "u" executable to "/usr/local/bin/u".
Assuming "/usr/local/bin/u" is in your $PATH you can now run "u" from anywhere on the command line.

### Caveats

* U is pretty Mac specfic at the moment.
* First couple of times you will have to approve accessibility control in the system preferences.
  This is so U can determine whether iTerm2 is not in focus and send messages to
  Notification Center instead.

### Usage

You can call a script and provide parameters like so:

	u extract article: http://medium.com/some-article-to-read-later

Where the script name follows "u" and the parameters follow the colon.

You can call methods that don't take parameters like so:

	u about

Fetch and set your background to a randomly selected nature image from wallhaven

	u get a wallpaper: 2560x1440 Mountains // OS X specific

### Write your own scripts

Your own scripts can be anywhere you like, but should be postfixed with `uscript.rb`.
To run them simply cd into the directory with your U scripts and run them!

Use the example.rb file in the packages folder as an easy way to get started writing your own scripts.

### Features

* If a script completes when iTerm2 doesn't have focus it will send you a notification.
* Builtin text extraction for web pages
* Notify yourself of finished jobs with Pushover


### Documentation

U configuration is stored as a JSON file. The default configuration is stored in ~/.u

Example JSON configuration

```
{
	"colorize": true			// make the output look pretty
	"personal_email": "foo@gmail.com"	// where email goes by default
}
```

### Available Built-ins for Scripts

Provides email address set to "personal_email"
```
me
```

Send a notification to your pushover devices, requires API keys
```
notify(message)
```

Send an email
```
email to: me, subject: 'U is awesome', body: 'Some plain text goes here'
```

Print messages to STDOUT with optional color levels. Available levels are
:error, :warn, or nil by default. If iTerm2 doesn't have focus when the message
is printed it will send a notification to OS X Notification Center.
```
uprint(message, :level) # level is a symbol or nil by default
```

Access settings in the users ~/.u/config file
```
settings.some_property
```


### Required API Keys and Environment Vars for Full Functionality

Services used:

* [Pushover](https://pushover.net/) for mobile notifications
* [Dandelion](https://dandelion.eu) for webpage text extraction

Environment Variables:

* PUSHOVER_USER_KEY
* PUSHOVER_APP_TOKEN
* DANDELION_TOKEN
* U_SMTP_ADDRESS
* U_SMTP_PORT
* U_EMAIL_ADDRESS
* U_EMAIL_PASSWORD

brew install sqlite sqlcipher
gem install sqlite3 --platform=ruby -- --with-opt-dir=/usr/local/Cellar/sqlcipher/3.4.1
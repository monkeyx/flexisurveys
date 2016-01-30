# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_QQ_session',
  :secret      => '45ff44f958f8758e5b341105bffacf6a2fcaa66274e8250b2811e1e582f8f52b60e3cb2ffa39259a666ae11ff1c1ef9c6547d5db4b576852d64d585bd3b930d7'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

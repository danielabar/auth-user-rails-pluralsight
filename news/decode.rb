require "cgi"
require "json"
require "active_support"
# require "uri"
require "base64"
require "openssl"

# Decrypt a cookie with Rails - instructors code doesn't work on Rails 6
def verify_and_decrypt_session_cookie(cookie, secret_key_base)
  cookie = CGI::unescape(cookie)

  salt = "encrypted cookie"
  signed_salt = "signed encrypted cookie"

  key_generator = ActiveSupport::KeyGenerator.new(secret_key_base, iterations: 1000)
  secret = key_generator.generate_key(salt)[0, ActiveSupport::MessageEncryptor.key_len]
  sign_secret = key_generator.generate_key(signed_salt)
  encryptor = ActiveSupport::MessageEncryptor.new(secret, sign_secret, serializer: JSON)

  encryptor.decrypt_and_verify(cookie)
end

# Copied from browesr cookie `_news_session` after logging out with "Show URL decoded" unchecked
cookie = 'M2n5chbqRrH8BcTShibfoJW1J%2Fjk%2BceoqDDKk3to%2FBElfEHZhEP24G6q1ksZ1%2FE5O62X2ZlkxNLvY39IAT6Kk3er5iRu%2BZxI5HbxPjroU3Vcm8RB0Ot7JKICk7auZb3bhSGTvGB0MiKvh%2FPjkBJd%2FSAretpR0ZBpLv1aiIsAgQsNMmCysOksYgpvoLyqAEKdGCAWxktpUxvcXRVH34taIN%2Bpr7q0DuZYOwFK%2FHqz1KKFIn9%2BPQm6UvB5M%2FwbB04zpV%2Fc1%2BGo%2FDkCPrZsv956YqDOlg9i--is%2B9rGtsSv9Df%2F3h--r0s8PHaWNusjHc9xl4tDJA%3D%3D'

# From Rails console: Rails.application.secret_key_base
secret_key_base = '4f7198c210578b2106158e708af896dd5eb1f9d99c3a95bbb3eaa30fb4b5a2f15f5b4c84d87c92fa3e18559e112ccc12198dd085b65b25a28bc48f23ee670c60'

p verify_and_decrypt_session_cookie(cookie, secret_key_base)
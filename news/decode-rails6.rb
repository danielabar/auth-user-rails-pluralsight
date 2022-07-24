require "cgi"
require "json"
require "active_support"
require "base64"
require "openssl"

# Decrypt a cookie with Rails
# from blog post: https://binarysolo.chapter24.blog/demystifying-cookies-in-rails-6/
# but had to use CGI instead of URI
def verify_and_decrypt_cookie(cookie, secret_key_base)
  cookie = CGI::unescape(cookie)
  data, iv, auth_tag = cookie.split("--").map do |v|
    Base64.strict_decode64(v)
  end
  cipher = OpenSSL::Cipher.new("aes-256-gcm")

  # Compute the encryption key
  secret = OpenSSL::PKCS5.pbkdf2_hmac_sha1(secret_key_base, "authenticated encrypted cookie", 1000, cipher.key_len)

  # Setup cipher for decryption and add inputs
  cipher.decrypt
  cipher.key = secret
  cipher.iv  = iv
  cipher.auth_tag = auth_tag
  cipher.auth_data = ""

  # Perform decryption
  cookie_payload = cipher.update(data)
  cookie_payload << cipher.final
  cookie_payload = JSON.parse cookie_payload
  # => {"_rails"=>{"message"=>"InRva2VuIg==", "exp"=>nil, "pur"=>"cookie.remember_token"}}

  # Decode Base64 encoded stored data
  decoded_stored_value = Base64.decode64 cookie_payload["_rails"]["message"]
  stored_value = JSON.parse decoded_stored_value
end

# Copied from browser cookie `_news_session` after logging out with "Show URL decoded" unchecked
cookie = 'M2n5chbqRrH8BcTShibfoJW1J%2Fjk%2BceoqDDKk3to%2FBElfEHZhEP24G6q1ksZ1%2FE5O62X2ZlkxNLvY39IAT6Kk3er5iRu%2BZxI5HbxPjroU3Vcm8RB0Ot7JKICk7auZb3bhSGTvGB0MiKvh%2FPjkBJd%2FSAretpR0ZBpLv1aiIsAgQsNMmCysOksYgpvoLyqAEKdGCAWxktpUxvcXRVH34taIN%2Bpr7q0DuZYOwFK%2FHqz1KKFIn9%2BPQm6UvB5M%2FwbB04zpV%2Fc1%2BGo%2FDkCPrZsv956YqDOlg9i--is%2B9rGtsSv9Df%2F3h--r0s8PHaWNusjHc9xl4tDJA%3D%3D'

# example logged in cookie
# cookie = 'o1e%2FaSuIDNZEffjMVV2iORgeIi06Uj2nO163xucCToB3i%2BI6g9cz8miIpBCdTYjccgb9DHduuJ3k4UX50XW0T%2BbB1jIH9aBhtY7I9Nvv35mls8vb6%2FLJX2iHIQqlJ03JbmjOOhj33Vnx%2BYKjpqMvNa5sO5jP%2BUIRj7NRtbEQNEBMkAbKK1UpjO5lwqM444T0aor6NQN1X6kn%2B719SIjJuu782wJ0tIgtuEj0zCGlwF9ws9EUqs28DNhLPh2CTs7fdsUjWw96BK5Q3vC76A%2FxDROg7GZjKkUqVMW3F548sxStqG8wSQ%3D%3D--n1Q7TIFjtc%2B%2Ft88T--rLWS0leMx%2FWCgFDXUTN7lg%3D%3D'

# From Rails console: Rails.application.secret_key_base
secret_key_base = '4f7198c210578b2106158e708af896dd5eb1f9d99c3a95bbb3eaa30fb4b5a2f15f5b4c84d87c92fa3e18559e112ccc12198dd085b65b25a28bc48f23ee670c60'

p verify_and_decrypt_cookie(cookie, secret_key_base)
# logged in cookie
# {"session_id"=>"6a0eb63ebc79b573a88388907e0031f3", "_csrf_token"=>"zZfEUV7uY6UUHEZr4AqQbyaNJ_U63GqJR_uM3HhOF70=", "user_id"=>1}

# logged out cookie
# {"session_id"=>"6a0eb63ebc79b573a88388907e0031f3", "_csrf_token"=>"zZfEUV7uY6UUHEZr4AqQbyaNJ_U63GqJR_uM3HhOF70="}
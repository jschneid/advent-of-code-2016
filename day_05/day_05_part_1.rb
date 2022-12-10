require 'digest/md5'

door_id = 'ojvtpuvg'
password = ''
index = 0

while password.length < 8
  hash = Digest::MD5.hexdigest(door_id + index.to_s)
  password += hash[5] if hash.start_with?('00000')
  index += 1
end

p password

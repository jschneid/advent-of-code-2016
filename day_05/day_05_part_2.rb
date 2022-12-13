require 'digest/md5'

door_id = 'ojvtpuvg'
password = '________'
index = 0
characters_found = 0

while characters_found < 8
  hash = Digest::MD5.hexdigest(door_id + index.to_s)
  if hash.start_with?('00000')
    position = hash[5].to_i(16)

    if position >= 0 && position < 8 && password[position] == '_'
      password[position] = hash[6]
      characters_found += 1
      p "Decrypting... Password: #{password}"
    end
  end
  index += 1
end

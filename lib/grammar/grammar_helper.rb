require File.dirname(__FILE__) + '/tokens/hash_token'

# Load automatically all token definition files from the directory tokens
Dir[File.dirname(__FILE__) + '/tokens/*_token.rb'].each do |token_file|
  require token_file
end

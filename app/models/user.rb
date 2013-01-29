class User < ActiveRecord::Base
  attr_accessible :cas_user, :token
end

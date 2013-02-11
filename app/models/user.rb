class User < ActiveRecord::Base
  attr_accessible :administrator, :cas_user, :token
end

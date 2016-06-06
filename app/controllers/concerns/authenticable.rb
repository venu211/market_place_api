module Authenticable

def current_user 
@current_user ||= User.find(auth_token: request.headers["Authorization"])
end

end
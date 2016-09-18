local csrf_token = require 'resty.csrf_token'
local token = csrf_token:new()
if token ~= nil then
    token:token()
end

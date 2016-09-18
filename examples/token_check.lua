local csrf_token = require 'resty.csrf_token'
local json = require 'cjson'
local token = csrf_token:new()
if token ~= nil then
    local res, err = token:filter()
    if res ~= true then
        ngx.say(json.encode({code = 501, message = err}))
    end
end


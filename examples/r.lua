local json = require 'cjson'
local ngx_req = ngx.req
ngx_req.read_body()
local data = ngx_req.get_post_args()
if data == nil then
    ngx.say(json.encode({code = 500, message = 'no request body'}))
end

if data.name == nil then
    ngx.say(json.encode({code = 501, message = 'the name can not be null'}))
end

ngx.say(json.encode({code = 200, message = 'success'}))
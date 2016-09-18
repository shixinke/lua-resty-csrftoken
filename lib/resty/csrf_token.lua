local ngx_header = ngx.header
local ngx_var = ngx.var
local ngx_req = ngx.req
local md5 = ngx.md5
local shdict = ngx.shared
local ngx_time = ngx.time
local _M = {
    _VERSION = '0.01'
}

local mt = {__index = _M }

function _M.new(self, dict_name, expire_time, token_name)
    self.token_name = token_name or 'X-CSRF-TOKEN'
    self.dict_name = dict_name or 'dict_csrf_token'
    self.dict = shdict[self.dict_name]
    self.expires = expire_time and tonumber(expire_time) or 60
    if self.dict == nil then
        return nil, 'the dict name does not exists'
    end
    return setmetatable(self, mt)
end

function _M.token(self)
    if ngx_req.get_method() == 'GET' then
        local value = md5(ngx_var.uri..ngx_time())
        self.dict:set(self.token_name, value, self.expires)
        ngx_header[self.token_name] = value
    else
        local value = self.dict:get(self.token_name)
        if value ~= nil then
            ngx_req.set_header(self.token_name, value)
        end
    end
end



function _M.filter(self)
    if ngx_req.get_method() ~= 'GET' then
        local header_token = ngx_req.get_headers()[self.token_name]
        if header_token == nil then
            return nil, 'no token in header'
        end
        local token = self.dict:get(self.token_name)
        if header_token == token then
            self.dict:delete(self.token_name)
            return true
        else
            return nil, 'token access is invalid'
        end
    end
end

return _M
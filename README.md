#lua-resty-csrftoken

防止CSRF跨站攻击的类库

#Overview

    lua_package_path '/the/path/to/your/project/lib/?.lua';
	lua_shared_dict dict_csrf_token 100m;

	server {
		location =/csrfget.html {
			default_type text/html;
			header_filter_by_lua_block {
				local csrf_token = require 'resty.csrf_token';
				local csrftoken = csrf_token:new();
                if csrftoken ~= nil then
                    csrftoken:token()
                end
			}
			root /data/www/web_root/;
		}

        location =/csrfpost {
             default_type text/html;
             access_by_lua_block {
                 local csrf_token = require 'resty.csrf_token';
                 local json = require 'cjson'
				 local csrftoken = csrf_token:new();
                 if csrftoken ~= nil then
                     local res, err = csrftoken:filter()
                     if res ~= true then
                         ngx.say(json.encode({code = 5001, message = err}))
                     end
                 end
             }
             content_by_lua_file /data/www/csrftoken/examples/r.lua;
        }
	}


#Methods

##new

用法:ok = csrftoken:new(dict_name, expire_time, token_name)

功能：初始化csrf_token模块

参数：
     
   dict_name:共享字典的名称(默认为dict_csrf_token，注：根据访问人数来确定字典的大小)
   
   expire_time:csrf_token的有效期(默认60s)

   token_name：存储的token的名称，必须与header提交的一致(默认为X-CSRF-TOKEN)

##token

用法:csrftoken:token()

功能：生成token，并将token保存到字典中，而且在响应头中添加token

##filter

用法:ok,err = csrftoken:filter()

功能：验证token是否合法

##注意点

目前在请求头发送token，需要在客户端完成，通过客户端在请求头中添加token

#contact

E-mail:ishixinke@qq.com

website:[www.shixinke.com](http://www.shixinke.com "诗心客的博客")
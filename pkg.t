local random = math.random
math.randomseed(tonumber(tostring(os.time()):reverse():sub(1, 9)))

local function capturestdout(command)
    local handle = io.popen(command)
    local output = handle:read("*a")
    handle:close()
    return output:gsub('[\n\r]', '')
end

local user = {}
user.name = capturestdout("git config user.name")
user.email = capturestdout("git config user.email") 

local function uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

--create a new package
if arg[1]=="-generate" then

  pkgname = arg[2] --name of new package
  os.execute("rm -rf "..pkgname) --temporary

  --generate package folders
  os.execute("mkdir "..pkgname)
  os.execute("mkdir "..pkgname.."/src")
  --os.execute("mkdir "..pkgname.."/test")
  --os.execute("mkdir "..pkgname.."/docs")
  
  --generate main source file
  os.execute("touch "..pkgname.."/src/"..pkgname..".t")
 
  --generate Package.toml
  file = io.open(pkgname.."/Project.toml", "w")
  file:write("name = \""..pkgname.."\"\n")
  file:write("uuid = \""..uuid().."\"\n")
  file:write("authors = [\""..user.name.."<"..user.email..">".."\"]".."\n")
  file:write("version = \"".."0.1.0".."\"\n\n")
  file:write("[deps]\n\n")
  file:write("[compat]\n")
  file:close()
end

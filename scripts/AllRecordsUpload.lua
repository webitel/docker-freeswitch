----
-- Upload All MP3 file to CDR Server without domain
----

api = freeswitch.API();
p = io.popen('find /recordings/ -maxdepth 1 -type f')
cdr_url = freeswitch.getGlobalVariable("cdr_url");
pattern = "%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x"

function shell(c)
  local o, h
  h = assert(io.popen(c,"r"))
  o = h:read("*all")
  h:close()
  return o
end

function file_exists(name)
   local f=io.open(name,"r")
   if f~=nil then io.close(f) return true else return false end
end

for file in p:lines() do
	if (file_exists(file) ) then
    	r = api:executeString("http_put "..cdr_url.."/sys/formLoadFile?id="..file:match(pattern).."&type=mp3 "..file);
    	freeswitch.consoleLog("debug", "[up.lua]: "..r);
    	if (r:gsub("%s*$", "") == '+OK') then
        	del = "/bin/rm -rf "..file;
        	freeswitch.consoleLog("debug", "[RecordUpload.lua]: "..del.."\n");
        	shell(del);
    	end
	end
end

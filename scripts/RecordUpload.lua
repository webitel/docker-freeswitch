----
-- Upload MP3 file to the CDR Server
----

uuid = argv[1];
domain = argv[2];
format = argv[3];
if format==nil then format = "mp3" end
emails = argv[4];
if emails==nil then emails = "none" end
name = argv[5];
if name==nil then name = "none" end

api = freeswitch.API();
freeswitch.msleep(2000);
rec_file = "/recordings/"..uuid.."_"..name;
cdr_url = freeswitch.getGlobalVariable("cdr_url");
freeswitch.consoleLog("info", "[RecordUpload.lua]: Session record stopped at "..uuid.."\n");

function shell(c)
  local o, h
  h = assert(io.popen(c,"r"))
  o = h:read("*all")
  h:close()
  return o
end

function file_exists(name)
   local f=io.open(name,"r")
   freeswitch.consoleLog("debug", "[RecordUpload.lua]: File exists "..name.."\n");
   if f~=nil then io.close(f) return true else return false end
end

if (file_exists(rec_file.."."..format) ) then
    ::upload:: freeswitch.consoleLog("debug", "[RecordUpload.lua]: "..uuid.." - uploading file\n");
    r = api:executeString("http_put "..cdr_url.."/sys/formLoadFile?domain="..domain.."&id="..uuid.."&type="..format.."&email="..emails.."&name="..name.." "..rec_file.."."..format);
    freeswitch.consoleLog("debug", "[RecordUpload.lua]: "..r);
    if (r:gsub("%s*$", "") == '+OK') then
        del = "/bin/rm -rf "..rec_file.."."..format;
        freeswitch.consoleLog("debug", "[RecordUpload.lua]: "..del.."\n");
        shell(del);
    else
        freeswitch.consoleLog("debug", "[RecordUpload.lua]: "..uuid.." - retrying upload in 30 sec\n");
        freeswitch.msleep(30000);
        goto upload
    end
end

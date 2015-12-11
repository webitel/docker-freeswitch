----
-- Upload FAX to the CDR Server
----

uuid = argv[1];
domain = argv[2];
emails = argv[3];
if emails==nil then emails = "none" end

api = freeswitch.API();
freeswitch.msleep(1000);
fax_file = "/recordings/"..uuid;
cdr_url = freeswitch.getGlobalVariable("cdr_url");
freeswitch.consoleLog("info", "[FaxUpload.lua]: Fax recieved - "..uuid.."\n");

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

if (file_exists(fax_file..".tif") ) then
        c = "/usr/bin/convert "..fax_file..".tif "..fax_file..".pdf";
        freeswitch.consoleLog("debug", "[FaxUpload.lua]: "..c);
        shell(c);
        freeswitch.msleep(2000);
        d = "/bin/rm -rf "..fax_file..".tif";
        shell(d);
        r = api:executeString("http_put "..cdr_url.."/sys/formLoadFile?domain="..domain.."&id="..uuid.."&type=pdf&email="..emails.." "..fax_file..".pdf");
        freeswitch.consoleLog("debug", "[RecordUpload.lua]: "..r);
	if (r:gsub("%s*$", "") == '+OK') then
		del = "/bin/rm -rf "..fax_file..".pdf";
		freeswitch.consoleLog("debug", "[FaxUpload.lua]: "..del.."\n");
		shell(del);
	end
end

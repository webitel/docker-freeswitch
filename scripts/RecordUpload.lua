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
email_sbj = argv[6];
if email_sbj==nil then email_sbj = "none" end
email_msg = argv[7];
if email_msg==nil then email_msg = "none" end

cdr_url = freeswitch.getGlobalVariable("cdr_url");
rec_file = "/recordings/"..session:getVariable("webitel_record_file_name");
freeswitch.consoleLog("INFO", "[RecordUpload.lua]: Session record stopped at "..uuid.."\n");
transfer_disposition = session:getVariable("transfer_disposition");
if transfer_disposition==nil then transfer_disposition = "nope" end
if ( transfer_disposition=="recv_replace" ) then
    freeswitch.consoleLog("INFO", "[RecordUpload.lua]: transfer_disposition is " ..transfer_disposition.. ". Exit!\n");
    return
end

api = freeswitch.API();
freeswitch.consoleLog("NOTICE", "[RecordUpload.lua]: transfer_disposition is " ..transfer_disposition.. "\n");

function shell(c)
  local o, h
  h = assert(io.popen(c,"r"))
  o = h:read("*all")
  h:close()
  return o
end

function file_exists(name)
   local f=io.open(name,"r")
   freeswitch.consoleLog("NOTICE", "[RecordUpload.lua]: File exists "..name.."\n");
   if f~=nil then io.close(f) return true else return false end
end

if (file_exists(rec_file) ) then
    ::upload:: freeswitch.consoleLog("INFO", "[RecordUpload.lua]: "..uuid.." - uploading file\n");
    r = api:executeString("http_put "..cdr_url.."/sys/formLoadFile?domain="..domain.."&id="..uuid.."&type="..format.."&email="..emails.."&name="..name.."&email_sbj="..email_sbj.."&email_msg="..email_msg.." "..rec_file);
    freeswitch.consoleLog("DEBUG", "[RecordUpload.lua]: "..r);
    if (r:match("OK") == 'OK') then
        del = "/bin/rm -rf "..rec_file;
        freeswitch.consoleLog("DEBUG", "[RecordUpload.lua]: "..del.."\n");
        shell(del);
    else
        freeswitch.consoleLog("NOTICE", "[RecordUpload.lua]: "..uuid.." - retrying upload in 30 sec\n");
        freeswitch.msleep(30000);
        goto upload
    end
else
    freeswitch.consoleLog("WARNING", "[RecordUpload.lua]: "..uuid.." File not found\n");
end

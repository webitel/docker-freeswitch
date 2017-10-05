----
-- Upload tcpdump to the CDR Server
----

uuid = argv[1];
duration = argv[2];
filters = argv[3];
if filters==nil then filters = "udp" end

api = freeswitch.API();
dump_file = "/recordings/"..uuid..".pcap";
cdr_url = freeswitch.getGlobalVariable("cdr_url");
freeswitch.consoleLog("info", "[DumpUpload.lua]: Dump was started at file "..dump_file.."\n");

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

c = "/scripts/tcpdump.sh "..dump_file.." "..duration.." '"..filters.."'";
freeswitch.consoleLog("debug", "[DumpUpload.lua]: "..c);
shell(c);

if (file_exists(dump_file) ) then

    ::upload:: freeswitch.consoleLog("debug", "[DumpUpload.lua]: "..dump_file.." - uploading\n");
    r = api:executeString("http_put "..cdr_url.."/sys/tcp_dump?id="..uuid.."&type=pcap "..dump_file);
    freeswitch.consoleLog("debug", "[DumpUpload.lua]: "..r);

    if (r:match("OK") == 'OK') then
        del = "/bin/rm -rf "..dump_file;
        freeswitch.consoleLog("debug", "[DumpUpload.lua]: "..del.."\n");
        shell(del);
    else
        freeswitch.consoleLog("debug", "[DumpUpload.lua]: "..dump_file.." - retrying upload in 30 sec\n");
        freeswitch.msleep(30000);
        goto upload
    end
else
    freeswitch.consoleLog("debug", "[DumpUpload.lua]: "..dump_file.." does not exist\n");
end

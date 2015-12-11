## FreeSWITCH

[FreeSWITCH](http://www.freeswitch.org/) - FREE Multi-Protocol Soft Switch from git.

Works only with [Webitel](http://webitel.ua/) [Advanced Call Router](https://github.com/webitel/acr)

## Environment Variables

The FreeSWITCH `latest` image for [Webitel](http://webitel.ua/) uses several environment variables

`CONF_SERVER`

This environment variable used for HTTP server and port with XML configurations.

`CDR_SERVER`

This environment variable used for uploading call records.

`EXT_SIP_IP`

This optional environment variable is used in sip profile for SIP. Default is `auto-nat`.

`EXT_RTP_IP`

This optional environment variable is used in sip profile for RTP. Default is `auto-nat`.

`LOGLEVEL`

This optional environment variable for FreeSWITCH log level. Default is `err`.

`ACR_SERVER`

This environment variable used for connection to ACR with FreeSWITCH `socket` application. You must set IP:PORT. 

Used in the `ACR` XML Dialplan extension:

	<extension name="ACR">
		<condition>
			<action application="socket" data="ACR_SERVER:10030 async full”/>
		</condition>
	</extension>

## Supported Docker versions

This image is officially supported on Docker version `1.9` and newest.

## User Feedback

### Issues
If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/webitel/docker-freeswitch/issues).


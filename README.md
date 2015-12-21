## FreeSWITCH

[![Build Status](https://dev.webitel.com/buildStatus/icon?job=build_FreeSWITCH_image)](https://dev.webitel.com/job/build_FreeSWITCH_image)

[FreeSWITCH](http://www.freeswitch.org/) - FREE Multi-Protocol Soft Switch from git.

Works only with [Webitel](http://webitel.ua/) [Advanced Call Router](https://github.com/webitel/acr)

## Environment Variables

The FreeSWITCH `latest` image for [Webitel](http://webitel.ua/) uses several environment variables

`CONF_SERVER`

This environment variable used for HTTP server and port with XML configurations.

`CDR_SERVER`

This environment variable used for uploading call records.

`SIPDOS`

Enable iptables rules.

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


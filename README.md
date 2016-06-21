## FreeSWITCH

[![Build Status](https://travis-ci.org/webitel/docker-freeswitch.svg?branch=master)](https://travis-ci.org/webitel/docker-freeswitch) [![Documentation Status](https://readthedocs.org/projects/webitel/badge/?version=latest)](http://api.webitel.com/en/latest/?badge=latest) 


[FreeSWITCH](http://www.freeswitch.org/) - FREE Multi-Protocol Soft Switch v1.6.9.

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

This image is officially supported on Docker version `1.11` and newest.

## User Feedback

### Issues
If you have any problems with or questions about this image, please contact us through a [Webitel JIRA](https://my.webitel.com/).


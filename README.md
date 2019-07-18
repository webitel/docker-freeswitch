## FreeSWITCH

[![Build Status](https://travis-ci.org/webitel/docker-freeswitch.svg?branch=master)](https://travis-ci.org/webitel/docker-freeswitch) [![Documentation Status](https://readthedocs.org/projects/webitel/badge/?version=latest)](http://api.webitel.com/en/latest/?badge=latest)


[FreeSWITCH](http://www.freeswitch.org/) - FREE Multi-Protocol Soft Switch v1.8.7

Works only with [Webitel](http://webitel.ua/) [Advanced Call Router](https://github.com/webitel/acr)

## Environment Variables

The FreeSWITCH `latest` image for [Webitel](http://webitel.ua/) uses several environment variables

Used in the `ACR` XML Dialplan extension:

    <extension name="ACR">
        <condition>
            <action application="socket" data="ACR_SERVER:10030 async full"/>
        </condition>
    </extension>

## User Feedback

### Issues
If you have any problems with or questions about this image, please contact us through a [Webitel JIRA](https://my.webitel.com/).

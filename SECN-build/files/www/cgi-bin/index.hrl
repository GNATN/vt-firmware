#!/usr/bin/haserl 
<%
# Get version string from banner
REV=`cat /etc/openwrt_version`
VERSION=`cat /etc/banner | grep Version`" "$REV

# Time
DATE=`date`
UPTIME=`uptime`
TZ=`cat /etc/TZ`

# Get USB Modem details
USBMODEM=`/bin/usbmodem.sh`
USBSERIAL=`ls /dev/ttyUSB*`
USBSTATUS=`ifconfig | grep -A 1 3g | grep "inet addr"`

# Set DHCP subnet to current subnet for Softphone Support
/bin/setdhcpsubnet.sh > /dev/null

# Get the Asterisk and Access Point confg parameters 
# from config file /etc/config/secn

# Asterisk configuration parameters
ENABLE=`uci get secn.asterisk.enable`
REGISTER=`uci get secn.asterisk.register`
HOST=`uci get secn.asterisk.host`
REGHOST=`uci get secn.asterisk.reghost`
SECRET=`uci get secn.asterisk.secret`

USERNAME=`uci get secn.asterisk.username`
DIALOUT=`uci get secn.asterisk.dialout`
CODEC1=`uci get secn.asterisk.codec1`
CODEC2=`uci get secn.asterisk.codec2`
CODEC3=`uci get secn.asterisk.codec3`
EXTERNIP=`uci get secn.asterisk.externip`
ENABLENAT=`uci get secn.asterisk.enablenat`
SOFTPH=`uci get secn.asterisk.softph`
ENABLE_AST=`uci get secn.asterisk.enable_ast`

# Access Point configuration parameters
SSID=`uci get secn.accesspoint.ssid`
ENCRYPTION=`uci get secn.accesspoint.encryption`
WPA_KEY_MGMT=`uci get secn.accesspoint.wpa_key_mgmt`
PASSPHRASE=`uci get secn.accesspoint.passphrase`
AP_DISABLE=`uci get secn.accesspoint.ap_disable`
USREG_DOMAIN=`uci get secn.accesspoint.usreg_domain`
MAXASSOC=`uci get secn.accesspoint.maxassoc`

# Set AP Connections to show 'Disabled' if reqd.
if [ $MAXASSOC = "0" ]; then
  MAXASSOC="Disabled"
fi 

# DHCP configuration parameters
DHCP_ENABLE=`uci get secn.dhcp.enable`
DHCP_AUTH=`uci get secn.dhcp.dhcp_auth`
STARTIP=`uci get secn.dhcp.startip`
ENDIP=`uci get secn.dhcp.endip`
MAXLEASES=`uci get secn.dhcp.maxleases`
LEASETERM=`uci get secn.dhcp.leaseterm`
DOMAIN=`uci get secn.dhcp.domain`
OPTION_SUBNET=`uci get secn.dhcp.subnet`
OPTION_ROUTER=`uci get secn.dhcp.router`

# MPGW setting
MPGW=`uci get secn.mpgw.mode`

# Get network settings from /etc/config/network and wireless

# br_lan configuration parameters
BR_IPADDR=`uci get network.lan.ipaddr`
BR_DNS=`uci get network.lan.dns`
BR_GATEWAY=`uci get network.lan.gateway`
BR_NETMASK=`uci get network.lan.netmask`

# mesh_0 configuration parameters
ATH0_IPADDR=`uci get network.mesh_0.ipaddr`
ATH0_NETMASK=`uci get network.mesh_0.netmask`
ATH0_SSID=`uci get wireless.ah_0.ssid`
ATH0_BSSID=`uci get wireless.ah_0.bssid`

# Radio
CHANNEL=`uci get wireless.radio0.channel`
ATH0_TXPOWER=`uci get wireless.radio0.txpower`
RADIOMODE=`uci get wireless.radio0.hwmode`
CHANBW=`uci get wireless.radio0.chanbw`

if [ $RADIOMODE = "11ng" ]; then
  # Display 802.11N-G mode
  RADIOMODE="802.11N-G"
else
  RADIOMODE="802.11G"
fi

# Get web server parameters
AUTH=`uci get secn.http.auth`
LIMITIP=`uci get secn.http.limitip`
ENSSL=`uci get secn.http.enssl`

# Get Asterisk registration status
/bin/get-reg-status.sh
REG_STATUS=`cat /tmp/reg-status.txt | awk '{print $5;}'`
REG_ACCT=`cat /tmp/reg-status.txt | awk '{print $1 " - " $2;}'`

if [ $REG_STATUS = "Registered" ]; then
  # Display Not Registered status
  REG_STATUS="Registered Acct"
else
  REG_STATUS="Not Registered"
fi
# Get WAN settings
WANPORT=`uci get secn.wan.wanport`
ETHWANMODE=`uci get secn.wan.ethwanmode`
WANIP=`uci get secn.wan.wanip`
WANGATEWAY=`uci get secn.wan.wangateway`
WANMASK=`uci get secn.wan.wanmask`
WANDNS=`uci get secn.wan.wandns`
WANSSID=`uci get secn.wan.wanssid`
WANENCR=`uci get secn.wan.wanencr`
WANPASS=`uci get secn.wan.wanpass`

# Get 3G USB Modem
MODEM_ENABLE=`uci get secn.modem.enabled`
MODEMSERVICE=`uci get secn.modem.service`
VENDOR=`uci get secn.modem.vendor`
PRODUCT=`uci get secn.modem.product`
APN=`uci get secn.modem.apn`
DIALSTR=`uci get secn.modem.dialstr`
APNUSER=`uci get secn.modem.username`
APNPW=`uci get secn.modem.password`
MODEMPIN=`uci get secn.modem.pin`
MODEMPORT=`uci get secn.modem.modemport`
%>
<% echo -en "content-type: text/html\r\n\r\n" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <title>SECN Configuration</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  <style type="text/css"> @import url(/lib/configstyle.css);  </style>
  <script type="text/javascript" src="/lib/jquery-1.7.1.min.js"></script>
  <script type="text/javascript" src="/lib/jquery.hashchange.min.js"></script>
  <script type="text/javascript" src="/lib/jquery.easytabs.min.js"></script>
  <script type="text/javascript" src="/lib/jquery.validate.min.js"></script>
  <script type="text/javascript" src="/lib/jquery.form.min.js"></script>
  <script type="text/javascript" src="/lib/vt_lib.js"></script>
</head>

<body>
<div class='banner'>
  <img class="logo" src="/images/vtlogo.png" alt="Village Telco">
  <div class="titletext"> 
    <h1 class="textbanner">SECN Configuration</h1> 
    <p>Firmware:<%=  $VERSION %></p>
    <p>Date:<%=  $DATE %></p>
  </div>
</div>

<div id="outer-container" class="tab-container" >
  <ul class='etabs'>
    <li class="tab"><a href="#tabs1-basic">Basic</a></li>
    <li class="tab"><a href="#tabs1-advanced">Advanced</a></li>
    <li class="tab"><a href="#tabs1-status">Status</a></li>
  </ul>

  <div class="panel-container">

  <!-- Basic Configuration Form -->
    <div id="tabs1-basic">
      <form name="MP" id="MP" method="GET" action="/cgi-bin/basic.has">

        <fieldset class="network">
          <legend>Network</legend>
          <table>
            <tr>
              <td class="label"><label for="BR_IPADDR">IP Address</label></td>
              <td class="field"><input type="text" name="BR_IPADDR" id="br_ipaddr" value="<%= $BR_IPADDR %>"></td>


              <td class="label"><label for="BR_GATEWAY">Gateway</label></td>
              <td class="field"><input type="text" name="BR_GATEWAY" id="br_gateway" value="<%= $BR_GATEWAY %>"></td>


              <td class="label"></td>
              <td class="field"></td>
            </tr>
        </table>
        <table>
          <tr>
          <td class="ast_reg"><%= $GATEWAY_STATUS %></td>
          </tr>
          </table>
        </fieldset>

        <fieldset class="wifi">
          <legend>WiFi Access Point (<%= $ENCRYPTION %>)</legend>
          <table>
            <tr>
              <td class="label"><label for="ssid"> Station ID </label></td>
              <td class="field"><input type="text" name="SSID" id="ssid" value="<%= $SSID %>"></td>

              <td class="label"><label for="passphrase"> Passphrase </label></td>
              <td class="field"><input  type="text" name="PASSPHRASE" id="passphrase" value="<%= $PASSPHRASE %>"></td>

              <td class="label"><label for="CHANNEL"> Channel </label></td>
              <td class="field">
              <SELECT name="CHANNEL" id="CHANNEL" >
              <option selected="<%= $CHANNEL %>"><%= $CHANNEL %></option>
              <option value="1">1</option>
              <option value="2">2</option>
              <option value="3">3</option>
              <option value="4">4</option>
              <option value="5">5</option>
              <option value="6">6</option>
              <option value="7">7</option>
              <option value="8">8</option>
              <option value="9">9</option>
              <option value="10">10</option>
              <option value="11">11</option>
              <option value="12">12</option>
              <option value="13">13</option>
              </SELECT></td>
            </tr>
          </table>
        </fieldset>

        <fieldset class="asterisk">
          <legend>VoIP / SIP Configuration</legend>
          <table>
            <tr>
              <td class="label"><label for="user">User Name</label></td>
              <td class="field"><input type="text" name="USER" id="user" value="<%= $USERNAME %>"> </td>

              <td class="label"><label>Password</label></td>
              <td class="field"><input  type="password" name="SECRET" id="secret" value="<%= $SECRET %>"></td>
            </tr>
            <tr>
              <td class="label"><label for="host">SIP Host</label></td>
              <td class="field"><input type="text" name="HOST" id="host" value="<%= $HOST %>"></td>
              <td class="label"><label>Dialout Code</label></td>
              <td class="field">
                <SELECT name="DIALOUT" id="dialout">
                <option selected="<%= $DIALOUT %>"><%= $DIALOUT %></option>
                <option value="#"> # </option>
                <option value="9"> 9 </option>
                <option value="0"> 0 </option>
                </SELECT></td>
            </tr>
            <tr>
              <td class="label"><label>SIP Enable</label></td>
              <td class="field"><input  type="checkbox" name="ENABLE" id="enable" value="checked" "<%= $ENABLE %>" ></td>

              <td class="label"><label> SIP Status </label> </td>
              <td class="ast_reg"> <label><%=  $REG_STATUS %></label> </td>
            </tr>
          </table>
        </fieldset>

        <fieldset class="password">
          <legend>Password</legend>
          <table>
            <tr>
              <td class="label"><label for="PASSWORD1">Enter Password</label></td>
              <td class="field"><input name="PASSWORD1" id="PASSWORD1" type="password" autocomplete ="off" value=$PASSWORD1></td>
              <td class="status"></td>
              <td class="label"><label for="PASSWORD2">Repeat Password</label></td>
              <td class="field"><input name="PASSWORD2" id="PASSWORD2" type="password" autocomplete ="off" value=$PASSWORD2></td>
              <td class="status"></td>
              <td class="field"> <INPUT TYPE="SUBMIT" name="BUTTON" value="Set Password" > </td>
            </tr>
          </table>
          <table>
            <tr>
              <td class="ast_reg"><%= $PASSWORD_STATUS %></td>
            </tr>
          </table>
        </fieldset>

        <fieldset class="password">
        <legend>Web Server Security and Timezone</legend>
          <table>
            <tr>
              <td class="label"><label>Limit IP Address</label></td>
              <td class="field"><input  type="checkbox" name="LIMITIP" id="limitip" value="checked" "<%= $LIMITIP %>" ></td>

              <td class="label"><label>Enable SSL</label></td>
              <td class="field"><input  type="checkbox" name="ENSSL" id="enssl" value="checked" $ENSSL ></td>

              <td class="label"><label for="tz">Time Zone</label></td>
              <td class="field"><input type="text" name="TZ" id="tz" value="<%= $TZ %>"> </td>

            </tr>
          </table>
        </fieldset>

        <table class="submitform">
          <tr>
            <td>
            <INPUT TYPE="SUBMIT" name="BUTTON" value="Refresh" >
            <INPUT TYPE="SUBMIT" name="BUTTON" value="Save" >
            <INPUT TYPE="SUBMIT" name="BUTTON" value="Restart Asterisk" >
            <INPUT TYPE="SUBMIT" name="BUTTON" value="Reboot" >
            </td>
          </tr>
        </table>

      </form>
    </div>  

    <!-- Advanced Configuration Form -->
    <div id="tabs1-advanced">
       <div class="tab-container" id="inner-container">
        <ul class='etabs'>
        <li class='tab'><a href="#tab-adv">Advanced</a></li>
        <li class='tab'><a href="#tab-adv2">WAN</a></li>
        <li class='tab'><a href="#tab-fw">Firmware</a></li>
        </ul>

        <div class="panel-container">
          <div id="tab-adv">
            <form name="MP-ADV" id="MP-ADV" method=GET action="/cgi-bin/config/conf-sub-adv.sh">

              Time: <%= $UPTIME %>  TZ: <%= $TZ %>

              <fieldset class="network-adv">
                <legend>Network</legend>
                <table>
                  <tr>
                    <td class="label"><label for="BR_IPADDR">IP Address</label></td>
                    <td class="field"><input type="text" name="BR_IPADDR" id="br_ipaddr" value="<%= $BR_IPADDR %>" ></td>
                    <td></td>
                    <td class="label"><label for="BR_GATEWAY">Gateway</label></td>
                    <td class="field"><input type="text" name="BR_GATEWAY" id="br_gateway" value="<%= $BR_GATEWAY %>" ></td>
                  </tr>

                  <tr>
                    <td class="label"><label for="BR_DNS">DNS</label></td>
                    <td class="field"><input type="text" name="BR_DNS" id="br_dns" value="<%= $BR_DNS %>" ></td>
                    <td></td>
                    <td class="label"><label for="BR_NETMASK">Netmask</label></td>
                    <td class="field"><input type="text" name="BR_NETMASK" id="br_netmask" value="<%= $BR_NETMASK %>" ></td>
                  </tr>
                </table>
              </fieldset>

    <fieldset class="wifi-adv">
      <legend> Radio</legend>

      <table>
        <tr>
          <td class="label"><label for="CHANNEL">Channel</label></td>
          <td class="field">
          <SELECT name="CHANNEL" id="CHANNEL" >
          <option selected="<%= $CHANNEL %>"><%= $CHANNEL %></option>
          <option value="1">1</option>
          <option value="2">2</option>
          <option value="3">3</option>
          <option value="4">4</option>
          <option value="5">5</option>
          <option value="6">6</option>
          <option value="7">7</option>
          <option value="8">8</option>
          <option value="9">9</option>
          <option value="10">10</option>
          <option value="11">11</option>
          <option value="12">12</option>
          <option value="13">13</option>
          </SELECT>
          </td>

          <td class="label"><label>US/Can (11 ch)</label></td>
          <td class="field">
            <input type="checkbox" name="USREG_DOMAIN" id="usreg_domain" value="checked" $USREG_DOMAIN ></td>

          <td class="label"><label for="ATH0_TXPOWER"> Tx Power 1-20</label></td>
          <td class="field"><input type="text" name="ATH0_TXPOWER" id="ath0_txpower" value="<%= $ATH0_TXPOWER %>"></td>
        </tr>
      </table>

      <table>
        <tr>
          <td class="label"><label for="RADIOMODE">Wifi Mode</label></td>
          <td class="field">
          <SELECT name="RADIOMODE" id="radiomode">
            <option selected="<%= $RADIOMODE %>"><%= $RADIOMODE %></option>
            <option value="802.11G">802.11G</option>
            <option value="802.11N-G">802.11N-G</option>
          </SELECT>
          </td>

          <td class="label"><label for="CHANBW">Chan BW</label></td>
          <td class="field">
          <SELECT name="CHANBW" id="chanbw">
            <option selected="<%= $CHANBW %>"><%= $CHANBW %></option>
            <option value="5">5MHz</option>
            <option value="10">10MHz</option>
            <option value="20">20MHz</option>
          </SELECT>
          </td>
        </tr>
      </table> 

    </fieldset>



    <fieldset class="wifi-adv">
      <legend> WiFi Access Point</legend>
      <table>
        <tr>
          <td class="label"><label for="ssid">SSID</label></td>
          <td class="field"><input type="text" name="SSID" id="ssid" value="<%= $SSID %>" ></td>
          <td></td>
        </tr>

        <tr>  
          <td class="label"><label>Passphrase</label></td>
          <td class="field"><input  type="text" name="PASSPHRASE" id="passphrase" value="<%= $PASSPHRASE %>" ></td>

          <td></td>

          <td class="label"><label>Encryption</label></td>
          <td class="field">
          <SELECT name="ENCRYPTION" id="encryption">
            <option selected="<%= $ENCRYPTION %>"><%= $ENCRYPTION %></option>
            <option value="WPA1">WPA1</option>
            <option value="WPA2">WPA2</option>
            <option value="WEP">WEP</option>
            <option value="NONE">None</option>
          </SELECT>
          </td>

          <td class="label"><label for="MAXASSOC">AP Connections</label></td>
          <td class="field">
          <SELECT name="MAXASSOC" id="MAXASSOC" >
          <option selected="<%= $MAXASSOC %>"><%= $MAXASSOC %></option>
          <option value="0">Disabled</option>
          <option value="1">1</option>
          <option value="2">2</option>
          <option value="5">5</option>
          <option value="10">10</option>
          <option value="15">15</option>
          <option value="20">20</option>
          <option value="25">25</option>
          </SELECT>
          </td>
        </tr>
      </table>
    </fieldset>


    <fieldset class="meshwifi">
      <legend> WiFi Mesh </legend>
      <table>
        <tr>
          <td class="label"><label for="ATH0_IPADDR">IP Address</label></td>
          <td class="field"><input type="text" name="ATH0_IPADDR" id="ath0_ipaddr" value="<%= $ATH0_IPADDR %>"></td>
          <td class="label"><label for="ATH0_NETMASK">Netmask</label></td>
          <td class="field"><input type="text" name="ATH0_NETMASK" id="ath0_netmask" value="<%= $ATH0_NETMASK %>"></td>
        </tr>
        <tr>
          <td class="label"><label for="ATH0_SSID"> SSID </label></td>
          <td class="field"><input type="text" name="ATH0_SSID" id="ath0_ssid" value="<%= $ATH0_SSID %>"></td>
          <td class="label"><label for="ATH0_BSSID"> BSSID </label></td>
          <td class="field"><input type="text" name="ATH0_BSSID" id="ath0_bssid" value="<%= $ATH0_BSSID %>"></td>
        </tr>
        <tr>
          <td class="label"><label>Gateway Mode</label></td>
          <td class="field">
          <SELECT name="MPGW" id="mpgw"/>
            <option selected="<%= $MPGW %>"><%= $MPGW %></option>
            <option value="OFF">OFF</option>
            <option value="CLIENT">CLIENT</option>
            <option value="SERVER">SERVER</option>
            <option value="SERVER-1Mb">SERVER 1Mb</option>
            <option value="SERVER-2Mb">SERVER 2Mb</option>
            <option value="SERVER-5Mb">SERVER 5Mb</option>
            <option value="SERVER-10Mb">SERVER 10Mb</option>
          </SELECT>
          </td>

          <td class="label"><label for="MESH_ENCR">Encryption</label></td>
          <td class="field">
          <SELECT name="MESH_ENCR" id="MESH_ENCR" >
            <option selected="off">OFF</option>
<!--        <option selected="<%= $MESH_ENCR %>"><%= $MESH_ENCR %></option>
            <option value="off">OFF</option>
            <option value="psk">WPA</option>
            <option value="psk2">WPA2</option> -->
          </SELECT>
          </td>
        </tr>

      </table>
    </fieldset>

              <fieldset class="asterisk-adv">
                <legend>Asterisk Configuration</legend>

                <table>
                  <tr>
                    <td class="label"><label>Enable Asterisk</label></td>
                    <td class"field"><input  type="checkbox" name="ENABLE_AST" id="enable_ast" value="checked" $ENABLE_AST > </td>
                    <td class="label"><label>Softphone Support</label></td>
                    <td class="field">
                      <SELECT name="SOFTPH" id="softph">
                        <option selected="<%= $SOFTPH %>"><%= $SOFTPH %></option>
                        <option value="OFF"> OFF </option>
                        <option value="CLIENT"> CLIENT </option>
                        <option value="MASTER"> MASTER </option>
                      </SELECT>
                    </td>
                  </tr>
                  <tr>
                    <td class="label"><label>Codec1</label></td>
                    <td class="field">
                      <SELECT name="CODEC1" id="codec1">
                        <option selected="<%= $CODEC1 %>"><%= $CODEC1 %></option>
                        <option value="gsm">gsm</option>
                        <option value="ulaw">ulaw</option>
                        <option value="alaw">alaw</option>
                      </SELECT>
                    <td class="label"><label>Codec2</label></td>
                    <td class="field">
                      <SELECT name="CODEC2" id="codec2">
                        <option selected="<%= $CODEC2 %>"><%= $CODEC2 %></option>
                        <option value="gsm">gsm</option>
                        <option value="ulaw">ulaw</option>
                        <option value="alaw">alaw</option>
                      </SELECT>
                    </td>
                    <td class="label"><label>Codec3</label></td>
                    <td class="field">
                      <SELECT name="CODEC3" id="codec3">
                        <option selected="<%= $CODEC3 %>"><%= $CODEC3 %></option>
                        <option value="gsm">gsm</option>
                        <option value="ulaw">ulaw</option>
                        <option value="alaw">alaw</option>
                      </SELECT>
                    </td>
                  </tr>
                    <tr>
                    <td class="label"><label>SIP Enable</label> </td>
                    <td class="field"><input  type="checkbox" name="ENABLE" id="enable" value="checked" <%= $ENABLE %> > </td>

                    <td class="label"><label>SIP Register</label></td>
                    <td class="field"><input  type="checkbox" name="REGISTER" id="register" value="checked" <%= $REGISTER %> > </td>

                    <td class="label"><label>Dialout Code</label></td>
                    <td class="field">
                      <SELECT name="DIALOUT" id="dialout">
                        <option selected="<%= $DIALOUT %>"><%= $DIALOUT %></option>
                        <option value="#"> # </option>
                        <option value="9"> 9 </option>
                        <option value="0"> 0 </option>
                      </SELECT>
                      </td>
                    </tr>
                </table>

                <table>
                  <tr>  
                    <td class="label"><label> SIP Status </label> </td>
                    <td class="ast_reg"><%=  $REG_STATUS $REG_ACCT %></td>
                  </tr>
                </table>

                <table>
                  <tr>
                    <td class="label"><label for="REGHOST">SIP Registrar</label> </td>
                    <td class="field"><input type="text" name="REGHOST" id="reghost" value="<%= $REGHOST %>" > </td>
                    <td class="label"><label for="USER">User Name</label></td>
                    <td class="field"><input type="text" name="USER" id="user" value="<%= $USERNAME %>" > </td>
                  </tr>
                  <tr>
                    <td class="label"><label for="HOST">SIP Host</label></td>
                    <td class="field"><input type="text" name="HOST" id="host" value="<%= $HOST %>" ></td>
                    <td class="label"><label for="SECRET">Password</label></td>
                    <td class="field"><input  type="text" name="SECRET" id="secret" value="<%= $SECRET %>" ></td>
                  </tr>
                  <tr>
                    <td class="label"><label>Enable Asterisk NAT</label></td>
                    <td class="field"><input  type="checkbox" name="ENABLENAT" id="enablenat" value="checked" $ENABLENAT > </td>
                    <td class="label"><label for="EXTERNIP">NAT External IP</label></td>
                    <td class="field"><input type="text" name="EXTERNIP" id="externip" value="<%= $EXTERNIP %>" > </td>
                  </tr>
                </table>
              </fieldset>

              <fieldset class="dhcp">
                <legend>DHCP Server</legend>

                <table>
                  <tr>
                    <td class="label"><label>Enable DHCP Server</label>
                    <td class="field"><input type="checkbox" name="DHCP_ENABLE" id="dhcp_enable" value="checked" $DHCP_ENABLE ></td>

                    <td class="label"><label>Authoritative</label>
                    <td class="field"><input type="checkbox" name="DHCP_AUTH" id="dhcp_auth" value="checked" $DHCP_AUTH ></td>
                  </tr>
                  <tr>
                    <td class="label"><label for="STARTIP">Starting IP</label></td>
                    <td class="field"><input type="text" name="STARTIP" id="startip" value="<%= $STARTIP %>" ></td>
                  
                    <td class="label"><label for="ENDIP">Ending IP</label></td>
                    <td class="field"><input type="text" name="ENDIP" id="endip" value="<%= $ENDIP %>" ></td>
                  </tr>
                  <tr>
                    <td class="label"><label for="OPTION_SUBNET"> Subnet Mask </label></td>
                    <td class="field"><input type="text" name="OPTION_SUBNET" id="option_subnet" value="<%= $OPTION_SUBNET %>" ></td>

                    <td class="label"><label for="OPTION_ROUTER"> Gateway Router </label></td>
                    <td class="field"><input type="text" name="OPTION_ROUTER" id="option_router" value="<%= $OPTION_ROUTER %>" ></td>
                  </tr>
                  <tr>
                    <td class="label"><label for="LEASETERM"> Lease Term (secs)</label></td>
                    <td class="field"><input type="text" name="LEASETERM" id="leaseterm" value="<%= $LEASETERM %>" ></td>
                    
                    <td class="label"><label for="MAXLEASES"> Max Leases </label></td>
                    <td class="field"><input type="text" name="MAXLEASES" id="maxleases" value="<%= $MAXLEASES %>" ></td>
                  </tr>
                  <tr>
                    <td class="label"><label for="DOMAIN"> Domain </label></td>
                    <td class="field"><input type="text" name="DOMAIN" id="domain" value="<%= $DOMAIN %>" ></td>
                  </tr>
                </table>
              </fieldset>

              <table class="submitform">
                <tr>
                  <td>
                    <INPUT TYPE="SUBMIT" name="BUTTON" value="Refresh">
                    <INPUT TYPE="SUBMIT" name="BUTTON" value="Save">
                    <INPUT TYPE="SUBMIT" name="BUTTON" value="Restart Asterisk">
                    <INPUT TYPE="SUBMIT" name="BUTTON" value="Restore Defaults" >
                    <INPUT TYPE="SUBMIT" name="BUTTON" value="Reboot" >
                  </td>
                </tr>
              </table>
            </form>
          </div>

    <!-- Advanced Configuration Form Tab 2-->
          <div id="tab-adv2">
            <form name="MP" method="GET" action="/cgi-bin/config/conf-sub-adv2.sh">
              <fieldset class="dhcp">
                <legend>WAN Configuration</legend>
                <table>
                  <tr>
                    <td class="label"><label> WAN Port</label></td>
                    <td class="field">
                    <SELECT name="WANPORT" id="wanport">
                      <option selected="<%= $WANPORT %>"><%= $WANPORT %></option>
                      <option value="Disable"> Disable </option>
                      <option value="Ethernet"> Ethernet </option>
                      <option value="USB-Modem"> USB-Modem </option>
                      <option value="WiFi"> WiFi </option>
                      </SELECT>
                    </td>
                    <td class="label"><label> Note: If a WiFi WAN port is selected, Mesh and AP interfaces are disabled on that port. </label> </td>
                  </tr>
                </table>

                <table>
                  <tr>
                    <td class="label"><label>WAN IP Mode</label></td>
                    <td class="field">
                    <SELECT name="ETHWANMODE" id="ethwanmode">
                      <option selected="<%= $ETHWANMODE %>"><%= $ETHWANMODE %></option>
                      <option value="DHCP"> DHCP </option>
                      <option value="Static"> Static </option>
                    </SELECT>
                    </td>
                  </tr>

                  <tr>  
                    <td class="label"><label> <H4>Static Network Settings</H4> </label> </td>
                  </tr>

                  <tr>
                    <td class="label"><label for="WANIP">Static IP</label></td>
                    <td class="field"><input type="text" name="WANIP" id="wanip" value="<%= $WANIP %>" ></td>
                    
                    <td class="label"><label for="WANGATEWAY">Gateway</label></td>
                    <td class="field"><input type="text" name="WANGATEWAY" id="wangateway" value="<%= $WANGATEWAY %>" ></td>
                  </tr>

                  <tr>
                    <td class="label"><label for="WANMASK">Netmask</label></td>
                    <td class="field"><input type="text" name="WANMASK" id="wanmask" value="<%= $WANMASK %>" ></td>
                    
                    <td class="label"><label for="WANDNS">DNS</label></td>
                    <td class="field"><input type="text" name="WANDNS" id="wandns" value="<%= $WANDNS %>" ></td>
                  </tr>


                  <tr>  
                    <td class="label"><label> <H4>WiFi WAN Host Settings</H4> </label> </td>
                  </tr>

                  <tr>
                    <td class="label"><label for="wanssid">SSID</label></td>
                    <td class="field"><input type="text" name="WANSSID" id="wanssid" value="<%= $WANSSID %>" ></td>
                    <td></td>
                  </tr>

                  <tr>  
                    <td class="label"><label>Passphrase</label></td>
                    <td class="field"><input  type="text" name="WANPASS" id="wanpass" value="<%= $WANPASS %>" ></td>


                    <td class="label"><label>Encryption</label></td>
                    <td class="field">
                    <SELECT name="WANENCR" id="wanencr">
                      <option selected="<%= $WANENCR %>"><%= $WANENCR %></option>
                      <option value="psk">WPA1</option>
                      <option value="psk2">WPA2</option>
                      <option value="wep">WEP</option>
                      <option value="none">None</option>
                    </SELECT>
                    </td>

                  </tr>

                  <tr>  
                    <td class="label"><label> <H4>USB Modem Settings</H4> </label> </td>
                  </tr>

                  <tr>
                    <td class="label"><label>USB Modem Service</label></td>
                    <td class="field">
                    <SELECT name="MODEMSERVICE" id="modemservice">
                      <option selected="<%= $MODEMSERVICE %>"><%= $MODEMSERVICE %></option>
                      <option value="umts"> UMTS </option>
                      <option value="gprs"> GPRS </option>
                      <option value="cdma"> CDMA </option>
                      <option value="evdo"> EV-DO </option>
                    </SELECT>
                  </td>
                  </tr>

                  <tr>
                    <td class="label"><label for="VENDOR">Vendor ID</label></td>
                    <td class="field"><input type="text" name="VENDOR" id="vendor" value="<%= $VENDOR %>" ></td>
                    
                    <td class="label"><label for="PRODUCT">Product ID</label></td>
                    <td class="field"><input type="text" name="PRODUCT" id="product" value="<%= $PRODUCT %>" ></td>
                  </tr>

                  <tr>
                    <td class="label"><label for="APN">Service APN</label></td>
                    <td class="field"><input type="text" name="APN" id="apn" value="<%= $APN %>" ></td>
                    
                    <td class="label"><label for="DIALSTR">Dial String</label></td>
                    <td class="field"><input type="text" name="DIALSTR" id="dialstr" value="<%= $DIALSTR %>" ></td>
                  </tr>

                  <tr>
                    <td class="label"><label for="APNUSER">Username</label></td>
                    <td class="field"><input type="text" name="APNUSER" id="apnuser" value="<%= $APNUSER %>" ></td>
                    
                    <td class="label"><label for="APNPW">Password</label></td>
                    <td class="field"><input type="text" name="APNPW" id="apnpw" value="<%= $APNPW %>" ></td>
                  </tr>

                  <tr>
                    <td class="label"><label for="MODEMPIN">PIN</label></td>
                    <td class="field"><input type="text" name="MODEMPIN" id="modempin" value="<%= $MODEMPIN %>" ></td>

                    <td class="label"><label>USB Serial Port</label></td>
                    <td class="field">
                    <SELECT name="MODEMPORT" id="modemport">
                      <option selected="<%= $MODEMPORT %>"><%= $MODEMPORT %></option>
                      <option value="0"> 0 </option>
                      <option value="1"> 1 </option>
                      <option value="2"> 2 </option>
                      <option value="3"> 3 </option>
                      <option value="4"> 4 </option>
                      <option value="5"> 5 </option>
                      <option value="6"> 6 </option>
                      <option value="7"> 7 </option>
                    </SELECT>
                    </td>
                  </tr>
                </table>

                <table>
                  <tr>  
                    <td class="label"><label> USB Device Detected</label> </td>
                    <td class="ast_reg"><%= $USBMODEM %></td>
                  </tr>
                </table>

                <table>
                  <tr>  
                    <td class="label"><label> USB Serial Ports Detected</label> </td>
                    <td class="ast_reg"><%= $USBSERIAL %></td>
                  </tr>
                </table>

                <table>
                  <tr>  
                    <td class="label"><label>USB Modem Status</label> </td>
                    <td class="ast_reg"><%= $USBSTATUS %></td>
                  </tr>
                </table>
              </fieldset>

              <table class="submitform">
                <tr>
                  <td>
                  <INPUT TYPE="SUBMIT" name="BUTTON" value="Refresh" >
                  <INPUT TYPE="SUBMIT" name="BUTTON" value="Save" >
                  <INPUT TYPE="SUBMIT" name="BUTTON" value="Reboot" >
                  </td>
                </tr>
              </table>
            </form>
          </div>

    <!-- Firmware Upgrade Page -->
          <div id="tab-fw">
            <h2><a href="/cgi-bin/upgrade">Firmware upgrade.</a></h2>
          </div>
        </div>
      </div>
    </div>

    <!-- Status Page -->
    <div id="tabs1-status">
      <p> </p>
      <h3> Available mesh nodes </h3>     
      <iframe id="FrameID1" src="/bat1.txt"  width="100%" height="150" ></iframe>
      <h3> Available gateways </h3>
      <iframe id="FrameID2" src="/bat2.txt"  width="100%" height="100" ></iframe>
      <h3> Mesh Neighbour Signal Strength</h3>
      <iframe id="FrameID3" src="/mesh.txt"  width="100%" height="100" ></iframe>
      <h3> WiFi Access Point connections</h3>
      <iframe id="FrameID4" src="/wifi.txt"  width="100%" height="100" ></iframe>
    </div>

  </div>
 </div>
</body>
</html>


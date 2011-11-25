XML_TYPE_5_3 = <<EOS
<?xml version="1.0" encoding="ISO-8859-1"?>
<monit>
  <server>
    <id>c0ca02784e2497827de003c276ce7d3f</id>
    <incarnation>1322226793</incarnation>
    <version>5.1.1</version>
    <uptime>1435</uptime>
    <poll>120</poll>
    <startdelay>0</startdelay>
    <localhostname>ks27535.kimsufi.com</localhostname>
    <controlfile>/etc/monit/monitrc</controlfile>
  </server>
  <platform>
    <name>Linux</name>
    <release>2.6.34.6-xxxx-grs-ipv6-64</release>
    <version>#3 SMP Fri Sep 17 16:06:38 UTC 2010</version>
    <machine>x86_64</machine>
    <cpu>2</cpu>
    <memory>2041276</memory>
  </platform>
  <service type="5"> 
    <collected_sec>1322228143</collected_sec>
    <collected_usec>48751</collected_usec>
    <name>ks27535.kimsufi.com</name>
    <status>0</status>
    <status_hint>0</status_hint>
    <monitor>1</monitor>
    <monitormode>0</monitormode>
    <pendingaction>0</pendingaction>
    <groups>
    </groups>
    <system>
      <load>
        <avg01>0.04</avg01>
        <avg05>0.01</avg05>
        <avg15>0.00</avg15>
      </load>
      <cpu>
        <user>1.9</user>
        <system>0.5</system>
        <wait>0.2</wait>
      </cpu>
      <memory>
        <percent>69.4</percent>
        <kilobyte>1417944</kilobyte>
      </memory>
    </system>
  </service>
  <service type="3">
    <collected_sec>1322228173</collected_sec>
    <collected_usec>53132</collected_usec>
    <name>postgres</name>
    <status>4608</status>
    <status_hint>0</status_hint>
    <monitor>1</monitor>
    <monitormode>0</monitormode>
    <pendingaction>0</pendingaction>
    <groups>
      <name>database</name>
    </groups>
    <status_message><![CDATA[failed to start]]></status_message>
  </service>
  <service type="3">
    <collected_sec>1322228173</collected_sec>
    <collected_usec>53221</collected_usec>
    <name>mailman</name>
    <status>0</status>
    <status_hint>0</status_hint>
    <monitor>1</monitor>
    <monitormode>0</monitormode>
    <pendingaction>0</pendingaction>
    <groups>
      <name>mail</name>
    </groups>
    <pid>5916</pid>
    <ppid>1</ppid>
    <uptime>5711945</uptime>
    <children>8</children>
    <memory>
      <percent>0.1</percent>
      <percenttotal>3.6</percenttotal>
      <kilobyte>2436</kilobyte>
      <kilobytetotal>74136</kilobytetotal>
    </memory>
    <cpu>
      <percent>0.0</percent>
      <percenttotal>0.0</percenttotal>
    </cpu>
  </service>
</monit>
EOS




EVENT_XML = <<EOS
<?xml version="1.0" encoding="ISO-8859-1"?>
<monit>
	<server>
		<id>c0ca02784e2497827de003c276ce7d3f</id>
		<incarnation>1321984838</incarnation>
		<version>5.1.1</version>
		<uptime>18</uptime>
		<poll>120</poll>
		<startdelay>0</startdelay>
		<localhostname>ks27535.kimsufi.com</localhostname>
		<controlfile>/etc/monit/monitrc</controlfile>
	</server>
	<platform>
		<name>Linux</name>
		<release>2.6.34.6-xxxx-grs-ipv6-64</release>
		<version>#3 SMP Fri Sep 17 16:06:38 UTC 2010</version>
		<machine>x86_64</machine>
		<cpu>2</cpu>
		<memory>2041276</memory>
	</platform>
	<service type="5">
		<collected_sec>1321984838</collected_sec>
		<collected_usec>966188</collected_usec>
		<name>myhost.mydomain.tld</name>
		<status>0</status>
		<status_hint>0</status_hint>
		<monitor>1</monitor>
		<monitormode>0</monitormode>
		<pendingaction>0</pendingaction>
		<groups>
		</groups>
		<system>
			<load>
				<avg01>0.09</avg01>
				<avg05>0.04</avg05>
				<avg15>0.01</avg15>
			</load>
			<cpu>
				<user>-1.0</user>
				<system>-1.0</system>
				<wait>-1.0</wait>
			</cpu>
			<memory>
				<percent>67.2</percent>
				<kilobyte>1373172</kilobyte>
			</memory>
		</system>
	</service>
</monit>
EOS






SYSTEM_XML = <<EOS
<?xml version="1.0" encoding="ISO-8859-1"?>
<monit id="73ca0df31d06eb2f1e02c9d6ffa367fe" incarnation="1321882955" version="5.3.1">
	<server>
		<uptime>-1</uptime>
		<poll>0</poll>
		<startdelay>0</startdelay>
		<localhostname>argamis.local</localhostname>
		<controlfile>test.rc</controlfile>
	</server>
	<platform>
		<name>Darwin</name>
		<release>11.2.0</release>
		<version>Darwin Kernel Version 11.2.0: Tue Aug  9 20:54:00 PDT 2011;root:xnu-1699.24.8~1/RELEASE_X86_64</version>
		<machine>x86_64</machine>
		<cpu>4</cpu>
		<memory>4194304</memory>
		<swap>2097152</swap>
	</platform>
	<services>
		<service name="postgres">
			<type>3</type>
			<collected_sec>1321882955</collected_sec>
			<collected_usec>564203</collected_usec>
			<status>512</status>
			<status_hint>0</status_hint>
			<monitor>2</monitor>
			<monitormode>0</monitormode>
			<pendingaction>0</pendingaction>
			<status_message><![CDATA[process is not running]]></status_message>
		</service>
		<service name="system_argamis.local">
			<type>5</type>
			<collected_sec>1321882955</collected_sec>
			<collected_usec>564813</collected_usec>
			<status>0</status>
			<status_hint>0</status_hint>
			<monitor>2</monitor>
			<monitormode>0</monitormode>
			<pendingaction>0</pendingaction>
		</service>
	</services>
	<servicegroups>
		<servicegroup name="database">
			<service>postgres</service>
		</servicegroup>
	</servicegroups>
	<event>
		<collected_sec>1321882955</collected_sec>
		<collected_usec>591375</collected_usec>
		<service>postgres</service>
		<type>3</type>
		<id>512</id>
		<state>1</state>
		<action>2</action>
		<message><![CDATA[process is not running]]></message>
	</event>
</monit>
EOS

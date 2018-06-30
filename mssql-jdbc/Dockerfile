# escape=`

ARG WILDFLY_VERSION=10.1.0.Final

FROM wuodan/wildfly-windows:$WILDFLY_VERSION

ENV JAVA_VERSION 8
ENV DRIVER_VERSION 6.4.0
ENV DRIVER_SHA512 518DAA58A7C21A74483B7AFC01A5E6C798D2C1DC24D0545414A83B92A592089251A686DF3191C925912C3C60C41A68DD9E7660DF604CF944E0ACA0C2AD58924A

ENV JBOSS_HOME C:\wildfly
ENV DRIVER_HOME "${JBOSS_HOME}\modules\system\layers\base\com\microsoft\sqlserver"

COPY sqlserver $DRIVER_HOME

COPY standalone.xml $JBOSS_HOME\standalone\configuration\standalone.xml.new

# https://github.com/Microsoft/mssql-jdbc/releases/download/v6.4.0/mssql-jdbc-6.4.0.jre8.jar
RUN $file = \"mssql-jdbc-$env:DRIVER_VERSION.jre$env:JAVA_VERSION.jar\"; `
	$url = \"https://github.com/Microsoft/mssql-jdbc/releases/download/v$env:DRIVER_VERSION/$file\"; `
	Write-Host "Downloading $file"; `
	Write-Host "from $url"; `
	Write-Host "to $env:DRIVER_HOME\main\$file"; `
	Invoke-WebRequest -Uri $url -OutFile $env:DRIVER_HOME\main\$file -Verbose; `
	ls $env:DRIVER_HOME; `
	ls $env:DRIVER_HOME\main; `
    Write-Host 'File Hash:'; `
    if ((Get-FileHash $env:DRIVER_HOME\main\$file -Algorithm SHA512).Hash -ne $env:DRIVER_SHA512) { `
        Write-Host 'FAILED!'; `
        exit 1; `
    }; `
	Write-Host 'Backing up standalone.xml to standalone.xml.orig, then overwriting it (why is there no simple patch command?)'; `
	mv $env:JBOSS_HOME\standalone\configuration\standalone.xml $env:JBOSS_HOME\standalone\configuration\standalone.xml.orig; `
	mv $env:JBOSS_HOME\standalone\configuration\standalone.xml.new $env:JBOSS_HOME\standalone\configuration\standalone.xml; `
	Write-Host "Setting driver version in $env:DRIVER_HOME\main\module.xml"; `
	(Get-Content $env:DRIVER_HOME\main\module.xml).replace('6.2.2.jre8', \"$env:DRIVER_VERSION.jre$env:JAVA_VERSION\") | Set-Content $env:DRIVER_HOME\main\module.xml; `
    Write-Host 'Done';
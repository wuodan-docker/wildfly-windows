# escape=`

FROM openjdk:8-jdk-nanoserver

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 10.1.0.Final
ENV WILDFLY_SHA512 DA19FC0FCB090B291FDC7E317BC7E30897AD4AB6BE1DEE3BDF374276BD7E1565CAD74E14979030C077CB4C5DFEF2CA6BCFF623CACC99DEAF02AC44C54727A362
ENV JBOSS_HOME C:/wildfly/

# Uncomment this copy command to use local wildfly zip archive, please read the comment further down
# COPY ./wildfly-10.1.0.Final.zip C:/

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN $file = \"wildfly-$env:WILDFLY_VERSION.zip\"; `
	$url = \"https://download.jboss.org/wildfly/$env:WILDFLY_VERSION/$file\"; `
# Comment out the next 4 lines if you use the above COPY with a local wildfly zip archive
	Write-Host "Downloading $file"; `
	Write-Host "from $url"; `
	Write-Host "to $file"; `
	Invoke-WebRequest -Uri $url -OutFile $file -Verbose; `
    Write-Host 'File Hash:'; `
    if ((Get-FileHash $file -Algorithm SHA512).Hash -ne $env:WILDFLY_SHA512) { `
        Write-Host 'FAILED!'; `
		Write-Host "got $(Get-FileHash $file -Algorithm SHA512).Hash"; `
        exit 1; `
    }; `
    Write-Host 'Expanding ZIP file'; `
#    Expand-Archive $file -DestinationPath C:/wildfly-$env:WILDFLY_VERSION; `
    Expand-Archive $file C:/; `
#    Move-Item wildfly-$env:WILDFLY_VERSION $env:JBOSS_HOME; `
    Write-Host 'Renaming folder'; `
    Rename-Item wildfly-$env:WILDFLY_VERSION wildfly; `
    Write-Host 'Deleting ZIP file'; `
    Remove-Item $file; `
    Write-Host 'Clearing standalone/deployments'; `
	mv "c:/wildfly/standalone/deployments" ""c:/wildfly/standalone/deployments.bak"; `
	md "c:/wildfly/standalone/deployments"; `
    Write-Host 'Done';

# Expose the ports we're interested in
EXPOSE 8080 9990 8787

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
# CMD [$JBOSS_HOME, "standalone.bat", "-b", "0.0.0.0"]
CMD ["C:\\wildfly\\bin\\standalone.bat", "-b", "0.0.0.0"]
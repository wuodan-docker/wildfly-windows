FROM openjdk:8-jdk-nanoserver

# Set the WILDFLY_VERSION env variable
ENV WILDFLY_VERSION 10.1.0.Final
ENV WILDFLY_SHA1 5EA0A70A483A4BEAF327FAEAF0A391208D33D4BD
ENV JBOSS_HOME C:/wildfly/

# Uncomment this copy command to use local wildfly zip archive, please read the comment further down
# COPY ./wildfly-10.1.0.Final.zip C:/

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN $file = \"wildfly-$env:WILDFLY_VERSION.zip\"; \
	$url = \"https://download.jboss.org/wildfly/$env:WILDFLY_VERSION/wildfly-$env:WILDFLY_VERSION.zip\"; \
# Comment out the next 2 lines if you use the above COPY with a local wildfly zip archive
	Write-Host 'Downloading $env:WILDFLY_VERSION';    \
	Invoke-WebRequest -Uri $url -OutFile wildfly-$env:WILDFLY_VERSION.zip -Verbose; \
    Write-Host 'File Hash:'; \
    if ((Get-FileHash $file -Algorithm sha1).Hash -ne $env:WILDFLY_SHA1) { \
        Write-Host 'FAILED!'; \
        exit 1; \
    }; \
    Write-Host 'Expanding ZIP file'; \
#    Expand-Archive $file -DestinationPath C:/wildfly-$env:WILDFLY_VERSION; \
    Expand-Archive $file C:/; \
#    Move-Item wildfly-$env:WILDFLY_VERSION $env:JBOSS_HOME; \
    Write-Host 'Renaming folder'; \
    Rename-Item wildfly-$env:WILDFLY_VERSION wildfly; \
    Write-Host 'Deleting ZIP file'; \
    Remove-Item $file; \
    Write-Host 'Clearing standalone/deployments'; \
	mv "c:/wildfly/standalone/deployments" ""c:/wildfly/standalone/deployments.bak"; \
	md "c:/wildfly/standalone/deployments"; \
    Write-Host 'Done';

# Expose the ports we're interested in
EXPOSE 8080 9990 8787

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
# CMD [$JBOSS_HOME, "standalone.bat", "-b", "0.0.0.0"]
CMD ["C:\\wildfly\\bin\\standalone.bat", "-b", "0.0.0.0", "--debug"]
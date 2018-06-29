# docker-wildfly-windows
Docker image running Wildfly on Windows

# sample usage
```
docker stop wildfly
docker rm wildfly

docker build --tag=wildfly C:\workspace\docker\image\wildfly

docker run -it ^
	-p 8080:8080 ^
	-p 9990:9990 ^
	-p 8787:8787 ^
	--name wildfly ^
	-v "C:/workspace/wildfly/standalone/deployments/":"c:/wildfly/standalone/deployments/"  ^
	-v "C:/workspace/wildfly/standalone/log/":"C:/wildfly/standalone/log/":rw  ^
	-v "C:/workspace/wildfly/modules/system/layers/base/com/microsoft/sqlserver/":"C:/wildfly/modules/system/layers/base/com/microsoft/sqlserver/" ^
	wuodan/wildfly-windows
  ```

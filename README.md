# tryplantanapp

## Deploying App and SQL Express containers
1. Clone https://github.com/dnnsharp/tryplantanapp on your local computer or server.
2. Go to the folder where you cloned the repository and open the **.env** file with a text editor.
   - For Windows 10 21H2 update, change the **windows_version** variable to look like `windows_version=21h2`.
   - For Windows Server 2019, change the **windows_version** variable to look like `windows_version=2019`
   - For Windows Server 2022, change the **windows_version** variable to look like `windows_version=2022`
3. Go to the folder where you cloned the repository and open a powershell with admin privileges here.
4. Type in: `.\RunPlantanapp.ps1 -Start` . This will automatically create the folders required and start the containers.
    - PS: Type only `.\RunPlantanapp.ps1` which will show you a helptext and examples of all parameters usage.
5. Wait to download and build the containers.
6. Access your new app on "localhost" or IP, or DNS, depending on where you deployed it. 


## Deploying App only (using your own SQL Server)
1. Open the **.env** file and change the **sa_password** and **base_connection** variables to correspond to your SQL Login.
2. Open the **docker-compose.yml** file and: 

	a. delete or comment the entire **mssql** service:
	```
	  mssql:
	    image: public.ecr.aws/n0h9y3l0/tryplantanapp-sql2017:win${windows_version}-${pa_version}
	    isolation: 'process'
	    volumes:
	      - "${db_folder_path}:C:/dbFiles/"
	    ports:
	      - '1433:1433'
	    environment:
	      ACCEPT_EULA: 'Y'
	      sa_password: ${sa_password}
	      attach_dbs: ${attach_dbs}
	    networks:
	      - appnet
	```
	b. in the 'web' service delete or comment the lines: 	
	```
	    depends_on:
	      - mssql
	``` 

<cfcomponent extends="lib.packages.org.corfield.framework">

<cfscript>

	this.name = hash(getCurrentTemplatePath());
	this.applicationTimeout = createTimeSpan(0,2,0,0);
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0,0,20,0);
	this.setClientCookies = false;
	this.scriptProtect = "cgi,cookies,url";
	//this.mappings[ "/lib" ] = REReplace(GetDirectoryFromPath( GetCurrentTemplatePath() ),"[^\\/]+[\\/]$","","one") & "lib";
	
	variables.framework = {
		action = 'action',
		defaultSection = 'home',
		defaultItem = 'default',
		home = 'home.default',
		error = 'home.error',
		reload = 'reinit',
		password = "1",
		reloadApplicationOnEveryRequest = true,
		generateSES = true,
		SESOmitIndex = true,
		base = '/lib',
		baseURL = 'useCgiScriptName',
		suppressImplicitService = true,
		unhandledExtensions = 'cfc',
		unhandledPaths = '/flex2gateway',
		preserveKeyURLKey = 'fw1pk',
		maxNumContextsPreserved = 3, // Set higher if you need multiple browser windows open (i.e. one per window)
		cacheFileExists = false,
		applicationKey = 'org.corfield.framework', 
		/*routes = [
			{"/search/"		= "/search/"},
			{"/sitemap/"		= "/sitemap/"},
			{"*" 				= "/pages/default/"}
		]*/
	};
		
	
	public function onMissingMethod() {}
	
	
	public function onMissingView()
	{
		if (application.config.mode eq 'dev')
		{
			dump(var="BIG FAT MISSING VIEW");
			dump(var=request.context, abort=true);
			writelog(text="On Missing View", file="fw1", type="error");
		}
		else 
		{
			location('/404.html');
		}
	}


	public boolean function setupApplication()
	{
		writeLog (file="#this.name#", type="Information", text="Application #this.name# starting...");

		appStart = getTickCount();
		application.appStartTime = now();
		application.applicationname = this.name;
		application.config = {
			admin.emailTo = "michael@learnosity.com",	
			admin.emailFrom = "error@mysite.com",
			admin.emailSubject = "Site error for mysite",
			dsn = "mysite",
			dsn_ro = "mysite_ro",
			servername = createObject("java", "java.net.InetAddress").localhost.getHostName(),
			clientFileVersion = 1
		}
		
		switch (application.config.servername)
		{
			case "marko-tomics-macbook-pro.local":
			case "markl-laptop":
			case "Neoptolemus":
			case "mark-lynchs-macbook-pro.local":				
			case "Peter-Phams-MacBook-Pro.local":
			case "noah":
			case "Matthew-MacBook-Pro.local":
				application.config.mode = "dev";
				application.config.logErrorsToFile = true;
				application.config.logLevels = "debug,error,fatal,information,warning";
				break;
				
			case "moya":
			case "davoip":
				application.config.mode = "preview";
				application.config.logErrorsToFile = true;
				application.config.logLevels = "debug,error,fatal,information,warning";
				
				// Override fw/1 defaults
				variables.framework.reloadApplicationOnEveryRequest = false;
				break;				
				
			default:
				application.config.mode = "production";
				application.config.logErrorsToFile = false;
				application.config.logLevels = "error,fatal,information,warning";
				// Override fw/1 defaults
				variables.framework.reloadApplicationOnEveryRequest = false;
				variables.framework.password = createUUID(); // Yeah...no reinit in production without restarting the instance
				break;			
		}

		application.cfcs = {}

		// This sites textual metadata
		application.site = {
			copyright = "",
			title = "Site name",
			subTitle = "",
			footer = "&copy; Learnosity #year(now())#",
			mask = {
				dt_long = "dd-mmm-yyyy"	
			}
		}
	
		writeLog (file="#this.name#", type="Information", text="Application #this.name# started. Time taken: #getTickCount() - appStart#ms");

		return true;
	}


	public function setupRequest()
	{
		setLocale("English (Australian)");
	}
	
	
	public function onError(exception,eventname) 
	{
		writelog(text="Type: #arguments.exception.type# . Message: #arguments.exception.message# . Detail: #arguments.exception.detail#", file=this.name, type="Error");
		setView(variables.framework.error);
		super.onError(arguments.exception,arguments.eventname);
	}
	
</cfscript>

</cfcomponent>
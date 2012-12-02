<cfcomponent extends="lib.packages.org.corfield.framework">

<cfscript>

	this.name = hash(getCurrentTemplatePath());
	this.applicationTimeout = createTimeSpan(0,2,0,0);
	this.sessionManagement = true;
	this.sessionTimeout = createTimeSpan(0,0,20,0);
	this.setClientCookies = false;
	this.scriptProtect = "cgi,cookies,url";
	this.mappings[ "/lib" ] = REReplace(GetDirectoryFromPath( GetCurrentTemplatePath() ),"[^\\/]+[\\/]$","","one") & "lib";

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
		application.config = new lib.model.utils.INIParser('/lib/config/config.ini').parse();
		application.config.environment["servername"] = createObject("java", "java.net.InetAddress").localhost.getHostName();
		application.cfcs = {};

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


	/**
	 * @hint We need to override variables.framework values, only way to do this is pre-fw/1 onRequestStart() as setupRequest() is called later in the call stack
	 **/
	public any function onRequestStart(string targetPath)
	{
		if (isDefined("application.config.environment.mode"))
		{
			// Override fw/1 defaults
			if (getConfig("environment").mode == "development")
			{
				variables.framework.reloadApplicationOnEveryRequest = true;
			}
			else if (getConfig("environment").mode == "production")
			{
				variables.framework.disableReloadApplication = true;
			}
		}

		super.onRequestStart(targetPath);
	}


	/**
	* @hint Returns either the full config structure (application.config), or a specific key inside the config struct
	*/
	private struct function getConfig(string key)
	{
		if (structKeyExists(arguments, "key") && len(arguments.key))
		{
			return application.config[key];
		}
		else
		{
			return application.config;
		}
	}

</cfscript>

</cfcomponent>
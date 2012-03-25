<cfcomponent output="false">


	<cfscript>

		this.name = "newproject";
		this.applicationTimeout = createTimeSpan(0,2,0,0);
		this.sessionManagement = true;
		this.sessionTimeout = createTimeSpan(0,0,20,0);
		this.setClientCookies = true;
		this.scriptProtect = "all";
		this.mappings[ "/lib" ] = REReplace(GetDirectoryFromPath( GetCurrentTemplatePath() ),"[^\\/]+[\\/]$","","one") & "lib";
	
	</cfscript>

	
	<cffunction name="onApplicationStart" returnType="boolean" output="false">
		
		<cflog file="#this.name#" type="Information" text="Application #this.name# starting...">

		<cfscript>
			
			appStart = getTickCount();
			application.config.admin.emailTo = "michael@learnosity.com";
			application.config.admin.emailFrom = "error@site.com.au";
			application.config.admin.emailSubject = "Site - error";
			application.config.dsn = "";			//Read/Write datasource hits only the 'master' database server (not as quick)
			application.config.dsn_ro = "";			//Read-only datasource can hit either database server in the cluster
			application.config.path.images = "/images";
			application.config.path.www = "/";
			application.config.reinitkey = "101";
			
			application.config.mode = "dev";
			
		</cfscript>
		
		<cflog file="#this.name#" type="Information" text="Application #this.name# started. Time taken: #getTickCount() - appStart#ms">

		<cfreturn true>
	</cffunction>


	<cffunction name="onApplicationEnd" returnType="void" output="false">
		<cfargument name="applicationScope" required="true">
		
		<cflog file="#arguments.applicationScope.applicationname#" type="Information" text="Application #arguments.applicationScope.config.mode# Ended">
	</cffunction>


	<cffunction name="onError" returnType="void" output="false">
		<cfargument name="exception" required="true">
		<cfargument name="eventname" type="string" required="true">

		<!--- Fixes cflocation bug which calls onError() in CF8.0 --->
		<cfif structKeyExists(arguments.exception, "type") AND arguments.exception.type EQ "coldfusion.runtime.AbortException">
			<cfreturn>
		</cfif>	

		<!--- Display the error if in dev (or debugging is turned on) --->
		<cfif isDebugMode() OR application.config.mode EQ "dev">
			<cfdump var='#arguments.exception#'>
			<cfabort>
		</cfif>	
	</cffunction>
	
	
	<cffunction name="onMissingTemplate" returnType="boolean" output="false">
		<cfargument name="targetpage" required="true" type="string">
		
		<cfreturn true>
	</cffunction>
	
	
	<cffunction name="onRequestStart" returnType="boolean" output="false">
		<cfargument name="thePage" type="string" required="true">
		
		<cfscript>
			
			setLocale("English (Australian)");

			checkReInit();
		
			return true;
		
		</cfscript>
	</cffunction>


	<cffunction name="onRequestEnd" returnType="void" output="false">
		<cfargument name="thePage" type="string" required="true">
		
	</cffunction>


	<cffunction name="onSessionStart" returnType="void" output="false">
		
		
	</cffunction>


	<cffunction name="onSessionEnd" returnType="void" output="false">
		<cfargument name="sessionScope" type="struct" required="true">
		<cfargument name="appScope" type="struct" required="false">
	</cffunction>


	<!--- PRIVATE METHODS --->
	<cffunction name="checkReInit" access="private" output="false" returnType="void" hint="Check whether we need to re-initialise the application scope (dev and stage only)">

		<cfscript>
			
			param name="application.config.mode" default="";
			switch(application.config.mode)
			{
				case "dev":
				case "staging":
					if (structKeyExists(URL, "updateapp") && URL.updateapp === application.config.reinitkey)
					{
						structClear(application);
						onApplicationStart();
					}
					break;
				default:				
					break;
			}			
			
		</cfscript>
	
	</cffunction>
		
	
</cfcomponent>
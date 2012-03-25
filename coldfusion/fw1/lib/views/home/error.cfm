<cfoutput>
<p class="alert-message error">An error occurred!</p>

<cfif structKeyExists( request, 'failedAction' )>
	<p><strong>Action:</strong> #request.failedAction#</p>
</cfif>

<cfif StructKeyExists(request, 'event')>
<p><strong>Event:</strong> #request.event# <br />
</cfif>

<cfif StructKeyExists(request, 'failedMethod')>
<p><strong>Failed Method:</strong> #request.failedMethod# <br />
</cfif>

<cfif StructKeyExists(request, 'failedCfcName')>
<p><strong>Failed CFC:</strong> #request.failedCfcName# <br />
</cfif>

<p><strong>Error:</strong> #request.exception.cause.message#</p>
<p><strong>Type:</strong> #request.exception.cause.type#</p>
		

<p><strong>Details:</strong> #request.exception.cause.detail#</p>

<cfdump var="#request.exception#">

</cfoutput>
<cfsetting enablecfoutputonly="true">

<cfif thisTag.executionMode == "start" && structKeyExists(request.context, "messages") && isValid("query", request.context.messages)>
	
	<cfset types = [
		{type = "success", css = "success"},
		{type = "error", css = "error"},
		{type = "warning", css = "warning"},
		{type = "information", css = "info"}
	]>

	<cfloop array="#types#" index="i">
		<cfquery name="#i.type#" dbtype="query">
			SELECT	*
			FROM	request.context.messages
			WHERE	type = '#i.type#'
		</cfquery>
	</cfloop>

	<cfloop array="#types#" index="i">
		<cfoutput query="#i.type#" group="title">
			<div class="alert-message block-message #i.css#">
				<p><strong>#trim(title)#</strong></p>
				<cfif len(trim(detail))>
					<ul>
						<cfoutput><li>#trim(detail)#</li></cfoutput>
					</ul>
				</cfif>
			</div>
		</cfoutput>
	</cfloop>

</cfif>
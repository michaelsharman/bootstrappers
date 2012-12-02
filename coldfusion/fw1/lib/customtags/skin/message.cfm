<cfsetting enablecfoutputonly="true" />
<!---
	Name			: message.cfm
	Author			: Michael Sharman
	Created		: September 07, 2012
	Last Updated	: September 07, 2012
	History			: Initial release (mps 07/09/2012)
	Purpose		: Displays an HTML list of messages
					: Expects a struct with at least 2 keys:
						- messages (Array[1])
						- title (String)
						- [type (String)]
 --->

<cfif NOT structKeyExists(attributes, "data") OR NOT isValid("struct", attributes.data)>
	<cfoutput>Please pass a valid messages struct</cfoutput>
	<cfabort>
</cfif>

<cfparam name="attributes.data.title" default="An error has occured">
<cfparam name="attributes.data.type" default="error">

<cfoutput>
	<div class="#attributes.data.type#">
		<h3>#attributes.data.title#</h3>
		<ul>
			<cfloop array="#attributes.data.messages#" index="m">
				<li>#m#</li>
			</cfloop>
		</ul>
	</div>
</cfoutput>
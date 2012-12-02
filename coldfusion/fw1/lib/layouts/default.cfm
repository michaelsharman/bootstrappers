<cfsetting enablecfoutputonly="true">

<cfcontent reset="true">

<cfimport taglib="/lib/customtags/skin" prefix="skin">

<cfset params = {}>

<skin:header params="#params#">

<cfoutput>
	#trim(body)#
</cfoutput>

<skin:footer params="#params#">
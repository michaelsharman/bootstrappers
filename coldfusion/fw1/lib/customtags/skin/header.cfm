<cfsetting enablecfoutputonly="true">

<cfparam name="attributes.params.title" default="#application.config.site.title#">
<cfparam name="attributes.params.subTitle" default="#application.config.site.subTitle#">
<cfparam name="attributes.params.bodyClass" default="">

<cfoutput><!DOCTYPE html>
<!--[if lt IE 7]>  <html lang="en" class="no-js ie ie6 lte9 lte8 lte7"> <![endif]-->
<!--[if IE 7]>     <html lang="en" class="no-js ie ie7 lte9 lte8 lte7"> <![endif]-->
<!--[if IE 8]>     <html lang="en" class="no-js ie ie8 lte9 lte8"> <![endif]-->
<!--[if IE 9]>     <html lang="en" class="no-js ie ie9 lte9"> <![endif]-->
<!--[if gt IE 9]>  <html lang="en" class="no-js"> <![endif]-->
<!--[if !IE]><!--> <html lang="en" class="no-js"> <!--<![endif]-->
<head>
	<!-- #application.appStartTime# | #application.config.environment.servername# | #application.config.environment.mode# -->
	<meta charset="utf-8">
	<title>#attributes.params.title#<cfif len(attributes.params.subTitle) and attributes.params.subTitle neq attributes.params.Title > :: #attributes.params.subTitle#</cfif></title>
	<meta name="description" content="">
	<cfif listFindNoCase("dev", application.config.environment.mode) && !request.simulateProduction>
		<link rel="stylesheet" type="text/css" href="/static/css/main.css" media="all">
	<cfelse>

	</cfif>
	<!--[if lt IE 9]>
		<script src="/static/js/_libs/html5shiv/html5shiv-printshiv.js"></script>
	<![endif]-->
	<cfif application.config.environment.mode == "production">
	<script type="text/javascript">
		var _gaq = _gaq || [];
		_gaq.push(['_setAccount', '']);
		_gaq.push(['_trackPageview']);
		(function() {
			var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
			ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
			var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		})();
	</script>
	</cfif>
</head>

<body<cfif len(attributes.params.bodyClass)> class="#attributes.params.bodyClass#"</cfif>>
	<div class="skipnav">
		<a href="##main_content">skip to main content</a>
	</div>
	<header>
		<a href="/">Main title <small>keyline</small></a>

	</header>
</cfoutput>
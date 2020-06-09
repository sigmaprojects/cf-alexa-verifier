

<cfscript>

alexaVerifier = new AlexaVerifierCF10();
data = '{"version":"1.0","session":{"new":false,"sessionId":"amzn1.echo-api.session.7ca6790a-2586-4b31-a7a8-e26b453fe016","application":{"applicationId":"amzn1.ask.skill.209f3005-4f48-44c8-ad69-d7320fe79d18"},"user":{"userId":"amzn1.ask.account.AEYYRTRFFWJCLPZMTFED54OLOOQBVXI2GZC4HQ7IEQ65PRGDM7MEO6XU7PWYRAXQCNH33OLX4KC2XLYC3UJOEGE2CXGQOH5NSDZ4RKJN2R2SSD2FCQ3WAXHWGZC3LKDRYTGQULOMX3HOHZVBA3QVGJFVYOJQ3A5CILACJAY3ORHEQSJSSCWNV3IWPDSTAMRL6XZDU32ZNHXGUUA"}},"context":{"System":{"application":{"applicationId":"amzn1.ask.skill.209f3005-4f48-44c8-ad69-d7320fe79d18"},"user":{"userId":"amzn1.ask.account.AEYYRTRFFWJCLPZMTFED54OLOOQBVXI2GZC4HQ7IEQ65PRGDM7MEO6XU7PWYRAXQCNH33OLX4KC2XLYC3UJOEGE2CXGQOH5NSDZ4RKJN2R2SSD2FCQ3WAXHWGZC3LKDRYTGQULOMX3HOHZVBA3QVGJFVYOJQ3A5CILACJAY3ORHEQSJSSCWNV3IWPDSTAMRL6XZDU32ZNHXGUUA"},"device":{"deviceId":"amzn1.ask.device.AFQELMRVBRWOZISWFQZ2J5TTGYBW2GIPRDZSLKPJMWXG7ZSWKSON3CM5KJSOZ7IH5GCHDOHWFYWUTAF6AOPXWGQ52H5EQDCQ6L3ST7TXMG4W2HDU4GWPBECSDACAYMJW446P324HHYBLI47KVNFKWFCFVVWEFHGQRYIUJJ6HXCHAIR4T6X6M2","supportedInterfaces":{}},"apiEndpoint":"https://api.amazonalexa.com","apiAccessToken":"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6IjEifQ.eyJhdWQiOiJodHRwczovL2FwaS5hbWF6b25hbGV4YS5jb20iLCJpc3MiOiJBbGV4YVNraWxsS2l0Iiwic3ViIjoiYW16bjEuYXNrLnNraWxsLjIwOWYzMDA1LTRmNDgtNDRjOC1hZDY5LWQ3MzIwZmU3OWQxOCIsImV4cCI6MTU0MjMzNjQzMSwiaWF0IjoxNTQyMzMyODMxLCJuYmYiOjE1NDIzMzI4MzEsInByaXZhdGVDbGFpbXMiOnsiY29uc2VudFRva2VuIjpudWxsLCJkZXZpY2VJZCI6ImFtem4xLmFzay5kZXZpY2UuQUZRRUxNUlZCUldPWklTV0ZRWjJKNVRUR1lCVzJHSVBSRFpTTEtQSk1XWEc3WlNXS1NPTjNDTTVLSlNPWjdJSDVHQ0hET0hXRllXVVRBRjZBT1BYV0dRNTJINUVRRENRNkwzU1Q3VFhNRzRXMkhEVTRHV1BCRUNTREFDQVlNSlc0NDZQMzI0SEhZQkxJNDdLVk5GS1dGQ0ZWVldFRkhHUVJZSVVKSjZIWENIQUlSNFQ2WDZNMiIsInVzZXJJZCI6ImFtem4xLmFzay5hY2NvdW50LkFFWVlSVFJGRldKQ0xQWk1URkVENTRPTE9PUUJWWEkyR1pDNEhRN0lFUTY1UFJHRE03TUVPNlhVN1BXWVJBWFFDTkgzM09MWDRLQzJYTFlDM1VKT0VHRTJDWEdRT0g1TlNEWjRSS0pOMlIyU1NEMkZDUTNXQVhIV0daQzNMS0RSWVRHUVVMT01YM0hPSFpWQkEzUVZHSkZWWU9KUTNBNUNJTEFDSkFZM09SSEVRU0pTU0NXTlYzSVdQRFNUQU1STDZYWkRVMzJaTkhYR1VVQSJ9fQ.CtXVKdbKCkLE_VJ7jbyGSFi20rJ99mi04hcta1EOVOFu1t_SmgkWl2Vqy4seZ6BnlByVy0iKIMx7f-viZlC_AsSTjKEyLATbZIb0cDLjYTrV8kzfEJRRh8rQmeSVi9Q8PYJNEQiUBOebPWIqqNC1-Jd5A9QdpaGU4-UoAe4zHXNQOm7vSWni8X8q8DTp-KF1x1uAHy-f9nlSgsJ95LF7CoSNGBM0ntM6kKVVpqwxnL8Z5k4Ur8_Yvyam24jq-jbYXuquKrDmU09AL6GM7NzndsICvXvQZ1aAuM1G-luaqbMgqeKiP61vNOp6WgE7UUkTi9DoLnIWJ3T4cWE_7HZjKQ"},"Viewport":{"experiences":[{"arcMinuteWidth":246,"arcMinuteHeight":144,"canRotate":false,"canResize":false}],"shape":"RECTANGLE","pixelWidth":1024,"pixelHeight":600,"dpi":160,"currentPixelWidth":1024,"currentPixelHeight":600,"touch":["SINGLE"]}},"request":{"type":"SessionEndedRequest","requestId":"amzn1.echo-api.request.70d5d66f-310f-4f74-8e82-b6f275a35f93","timestamp":"2018-11-16T01:47:11Z","locale":"en-US","reason":"ERROR","error":{"type":"INVALID_RESPONSE","message":"An exception occurred while dispatching the request to the skill."}}}';
signature = "X/DakTWndDr6/kvXyYWly6q+JZUX8HYctr8RhpMF+TsduCCSuCNc8tmVAZEUUEPcIemz9SZmBmlTdItzPBf61AgOOKopJYHbnZa2P9GXx2BPTFUwVknSGArEsT3d3pY0RpQjG+5dbS7Dao6aSyLFwJPvGkS6WqblfER6RU+EZE54tR6swvJRCGvv3eHBVjn2o9qQ41c1KbP0xOZDYugCunPmimv7ZhcNqD8+jdn+m5W9SB1KQX9iYQD7dxQcN6STs5aztqxoUAJtvyRgaGXzyiLYeOmtVE/ucS7xyF6Z78RiskZgbK6GMC0BTyYNBsJRck9iyU5z/eECeTiT3zpGLQ==";
href = "https://s3.amazonaws.com/echo.api/echo-api-cert-6-ats.pem";

</cfscript>

<cfinvoke component="AlexaVerifierCF10" method="verifierManual" returnvariable="verifierManualRet">
<cfinvokeargument name="signatureCertChainUrlHeader" value="#href#"/>
<cfinvokeargument name="signatureHeader" value="#signature#"/>
<cfinvokeargument name="contentBody" value="#data#"/>
</cfinvoke>

<cfdump var='#verifierManualRet#' />
<cfabort>
<cfscript>
r = alexaVerifier.verifierManual(href,signature,data);
writedump(r);
abort;
/*
cfhttp(method="POST", charset="utf-8", url="https://cf-alexa-verifier.sigmaprojects.org/AlexaVerifier.cfc?method=verifier", result="httpResult") {
	cfhttpparam(type="header", name="Content-Type", value="application/json");
	cfhttpparam(type="header", name="Signature", value=signature);
	cfhttpparam(type="header", name="SignatureCertChainUrl", value=href);
	cfhttpparam(type="body", value=data);
}
writedump(httpResult);
abort;
*/
</cfscript>

<cfhttp method="POST" charset="utf-8" url="http://127.0.0.1:50904/AlexaVerifier.cfc?method=verifier" result="httpResult">
	<cfhttpparam type="header" name="Content-Type" value="application/json" />
	<cfhttpparam type="header" name="Signature" value="#signature#" />
	<cfhttpparam type="header" name="SignatureCertChainUrl" value="#href#" />
	<cfhttpparam type="body" value="#data#" />
</cfhttp>
<cfdump var=#httpResult# />


<cfset r = alexaVerifier.verifierManual(href,signature,data) />
<cfdump var=#r# label="local" />


<cfabort>

<cfscript>

abort;


alexaVerifier = new AlexaVerifier();
pemString = alexaVerifier.fetchCert(href).data;
validSig = alexaVerifier.isValidSignature(pemString,signature,toString(data));

writedump(validSig);

abort;



abort;
// https://github.com/jmding0714/alexa-skills-kit-java-master/blob/master/src/main/java/com/amazon/speech/speechlet/authentication/SpeechletRequestSignatureVerifier.java
// https://stackoverflow.com/questions/3151407/signature-verify-always-returns-false
// https://github.com/mreinstein/alexa-verifier
certHrefs = [
'https://s3.amazonaws.com/echo.api/echo-api-cert.pem',
'https://s3.amazonaws.com/echo.api/echo-api-cert-6-ats.pem'
];
alexaVerifier = new AlexaVerifier();
for(href in certHrefs) {
	pemString = alexaVerifier.fetchCert(href).data;
	res = alexaVerifier.validateCert(pemString);
	writedump(var=res,label=href);
	validSig = alexaVerifier.isValidSignature(pemString,'YWJiYw==','abc123');
	writedump(var=validSig,label='isValidSignature');
	writeOutput("<br />");
}


</cfscript>
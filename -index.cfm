<cfscript>
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
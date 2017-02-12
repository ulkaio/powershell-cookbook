$cred = Get-Credential
$login = Invoke-WebRequest http://www.facebook.com/login.php -SessionVariable fb
$login.Forms[0].Fields.email = $cred.GetNetworkCredential().UserName
$login.Forms[0].Fields.pass = $cred.GetNetworkCredential().Password
$mainPage = Invoke-WebRequest $login.Forms[0].Action -WebSession $fb -Body $login -Method Post
$mainPage.ParsedHtml.getElementById("notificationsCountValue").InnerText
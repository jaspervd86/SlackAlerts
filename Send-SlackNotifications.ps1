param($AlertID,$AlertName,$AlertDescription,$Severity,$DisplayName,$ResolutionState)
#Fill in your token here.
$Token = ""
import-module PSSlack
#Convert the Severity to a textual display.
If ($Severity -eq "2") {$SeverityText = "Critical"}
If ($Severity -eq "1") {$SeverityText = "Warning"}
If ($Severity -eq "0") {$SeverityText = "Informational"}
#Generate the weblink for the alert, requires a management server with the web console installed OR squared up.
#Example for Web console in SCOM: http://scom.contoso.com/OperationsManager?DisplayMode=Pivot&AlertID=$AlertID
#Example for Squared Up: http://squaredup.contoso.com/SquaredUpv3/drilldown/scomalert?id=$alertID

$Weblink = "http://squaredup.contoso.com/SquaredUpv3/drilldown/scomalert?id=$alertID"
#Create the pretext with variables.
[string]$Pretext = "$ResolutionState $SeverityText Alert"

#Create the message with the alert data.

New-SlackMessageAttachment -Color $([System.Drawing.Color]::red) `
                           -Title $AlertName `
                           -TitleLink $WebLink `
                           -Text $AlertDescription `
                           -Pretext $Pretext `
                           -AuthorName $DisplayName `
                           -AuthorIcon 'http://www.freeiconspng.com/uploads/alert-icon-red-11.png' `
                           -Fallback 'Your client is bad' |
    New-SlackMessage -Channel 'monitoring' `
                     -IconEmoji :bomb: `
                     -AsUser `
                     -Username 'SCOM Bot' |
    Send-SlackMessage -Token $Token
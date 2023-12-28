#GET tickets
$token = "XXXX"
$URL = "https://yourjitbitapp.azurewebsites.net/api/tickets"
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-type"  = "application/json"
  }
Invoke-RestMethod -Method GET -URI $URL -Headers $headers
#GET ticket
$token = "XXXX"
$URL = "https://yourjitbitapp.azurewebsites.net/api/ticket?id=171040"
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-type"  = "application/json"
  }
Invoke-RestMethod -Method GET -URI $URL -Headers $headers
#GET custom fields 
$token = "XXXX"
$URL = "https://yourjitbitapp.azurewebsites.net/api/TicketCustomFields?id=171040"
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-type"  = "application/json"
  }
Invoke-RestMethod -Method GET -URI $URL -Headers $headers
#POST new ticket
$categoryId = 329 #B3Care / Övrigt
$body = "THIS IS THE BODY"
$subject = "TESTAR LARM API"
$priorityId = 0
$tags = "THIS IS TAG"
$origin = "Opsgenie"
$assignedToUserId  = "5477" #Karol

$token = "XXXX"
$URL = "https://yourjitbitapp.azurewebsites.net/api/ticket?categoryId=$categoryId&body=$body&subject=$subject&priorityId=$priorityId&tags=$tags&origin=$origin&assignedToUserId=$assignedToUserId"
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-type"  = "application/json"
  }
Invoke-RestMethod -Method POST -URI $URL -Headers $headers
#POST custom field value in a ticket
$ticketId = 171481
$fieldId = 10
$value = "Event"

$token = "XXXX"
$URL = "https://yourjitbitapp.azurewebsites.net/api/SetCustomField?ticketId=$ticketId&fieldId=$fieldId&value=$value"
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-type"  = "application/json"
  }
Invoke-RestMethod -Method POST -URI $URL -Headers $headers
#POST close ticket
$ticketId = 171481
$statusId = 3 #Closed

$token = "XXXX"
$URL = "https://yourjitbitapp.azurewebsites.net/api/UpdateTicket?id=$ticketId&statusId=$statusId"
$headers = @{
    "Authorization" = "Bearer $token"
    "Content-type"  = "application/json"
  }
Invoke-RestMethod -Method POST -URI $URL -Headers $headers

